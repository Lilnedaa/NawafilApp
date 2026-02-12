import Foundation
import Combine
import CoreLocation

final class PrayerTimesViewModel: ObservableObject {

    // Location
    let locationManager = LocationManager()
    @Published var locationStatusText: String = ""
    @Published var locationErrorText: String = ""

    // API output
    @Published var timings: PrayerTimings?
    @Published var readableDate: String = ""
    @Published var hijriDate: String = ""
    @Published var hijriMonthNumber: Int = 0
    @Published var hijriMonthName: String = ""

    @Published var isLoading = false
    @Published var errorMessage: String?
    
    

    // Extra times
    @Published var duhaStartText: String = ""
    @Published var duhaEndText: String = ""
    
    
    //
    @Published var tomorrowTimings: PrayerTimings?
    @Published var tomorrowHijriDate: String = ""
    @Published var tomorrowHijriMonthNumber: Int = 0


    // ✅ قيام الليل (عام): بعد العشاء -> قبل الفجر
    @Published var qiyamStartText: String = ""
    @Published var qiyamEndText: String = ""

    // ✅ تهجد رمضان (ثلث أخير) - رمضان فقط
    @Published var showTahajjudRamadan: Bool = false
    @Published var tahajjudStartText: String = ""
    @Published var tahajjudEndText: String = ""

    // ✅ التراويح - رمضان فقط
    @Published var showTarawih: Bool = false
    @Published var tarawihText: String = ""

    // Settings
    private let method = 4
    private var timezoneID: String { TimeZone.current.identifier }

    private let duhaAfterSunriseMinutes = 20
    private let duhaBeforeDhuhrMinutes = 15

    private let endBufferBeforeFajrMinutes = 5
    private let qiyamAfterIshaMinutes = 0
    private let tarawihAfterIshaMinutes = 0

    private var cancellables = Set<AnyCancellable>()

    init() {
        bindLocation()
    }

    // MARK: - Location Flow

    func startLocationFlow() {
        locationErrorText = ""
        locationManager.requestPermission()
        locationManager.requestLocationOnce()
    }

    private func bindLocation() {
        locationManager.$authorization
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.locationStatusText = Self.statusText(status)
                if status == .denied || status == .restricted {
                    self?.locationErrorText = "فعّلي الموقع من الإعدادات عشان نعرض مواقيت دقيقة."
                }
            }
            .store(in: &cancellables)

        locationManager.$location
            .compactMap { $0 }
            .sink { [weak self] loc in
                Task { await self?.loadByLocation(loc) }
            }
            .store(in: &cancellables)
    }

    // MARK: - Fetch by Location

    @MainActor
    private func loadByLocation(_ loc: CLLocation) async {
        isLoading = true
        errorMessage = nil

        print("📍 device lat/lon:", loc.coordinate.latitude, loc.coordinate.longitude)
        print("🕒 device timezone:", TimeZone.current.identifier)

        do {
            // ✅ اليوم
            let res = try await AladhanAPIClient.fetchTimings(
                latitude: loc.coordinate.latitude,
                longitude: loc.coordinate.longitude,
                method: method,
                timezone: timezoneID,
                school: 0
            )

            timings = res.data.timings
            readableDate = res.data.date.readable
            hijriDate = res.data.date.hijri.date
            hijriMonthNumber = res.data.date.hijri.month.number
            hijriMonthName = res.data.date.hijri.month.ar ?? res.data.date.hijri.month.en
// بكره
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!

            let resTomorrow = try await AladhanAPIClient.fetchTimings(
                latitude: loc.coordinate.latitude,
                longitude: loc.coordinate.longitude,
                date: tomorrow,                  // 👈 هنا نمرر Date مباشرة
                method: method,
                timezone: timezoneID,
                school: 0
            )

            tomorrowTimings = resTomorrow.data.timings
            tomorrowHijriDate = resTomorrow.data.date.hijri.date
            tomorrowHijriMonthNumber = resTomorrow.data.date.hijri.month.number

            tomorrowTimings = resTomorrow.data.timings
            tomorrowHijriDate = resTomorrow.data.date.hijri.date
            tomorrowHijriMonthNumber = resTomorrow.data.date.hijri.month.number

            // رمضان؟
            showTarawih = (hijriMonthNumber == 9)
            showTahajjudRamadan = (hijriMonthNumber == 9)

            computeAllExtras()

        } catch {
            errorMessage = "فشل جلب المواقيت حسب موقعك: \(error.localizedDescription)"
        }

        isLoading = false
    }


    private func computeAllExtras() {
        guard let timings else { return }
        let tz = TimeZone.current
        let day = Date()

        // الضحى
        if let (start, end) = computeDuha(timings: timings, day: day, tz: tz) {
            duhaStartText = formatArabicTime(start, tz: tz)
            duhaEndText = formatArabicTime(end, tz: tz)
        } else {
            duhaStartText = ""
            duhaEndText = ""
        }

        // قيام الليل (عام): بعد العشاء -> قبل الفجر
        if let window = computeQiyamGeneral(timings: timings, day: day, tz: tz) {
            qiyamStartText = formatArabicTime(window.start, tz: tz)
            qiyamEndText = formatArabicTime(window.end, tz: tz)
        } else {
            qiyamStartText = ""
            qiyamEndText = ""
        }

        // تهجد رمضان (ثلث أخير): المغرب -> الفجر (رمضان فقط)
        if showTahajjudRamadan,
           let window = computeTahajjudRamadanLastThird(timings: timings, day: day, tz: tz) {
            tahajjudStartText = formatArabicTime(window.start, tz: tz)
            tahajjudEndText = formatArabicTime(window.end, tz: tz)
        } else {
            tahajjudStartText = ""
            tahajjudEndText = ""
        }

        // التراويح (رمضان فقط): بعد العشاء
        if showTarawih, let isha = parseTime(timings.Isha, on: day, tz: tz) {
            let start = addMinutes(isha, tarawihAfterIshaMinutes)
            tarawihText = "التراويح: بعد العشاء (\(formatArabicTime(start, tz: tz)))"
        } else {
            tarawihText = ""
        }
    }

    // MARK: - Calculations

    private func computeDuha(timings: PrayerTimings, day: Date, tz: TimeZone) -> (start: Date, end: Date)? {
        guard
            let sunrise = parseTime(timings.Sunrise, on: day, tz: tz),
            let dhuhr = parseTime(timings.Dhuhr, on: day, tz: tz)
        else { return nil }

        let start = addMinutes(sunrise, duhaAfterSunriseMinutes)
        let end = addMinutes(dhuhr, -duhaBeforeDhuhrMinutes)
        guard end > start else { return nil }
        return (start, end)
    }

    /// ✅ قيام الليل العام: بعد العشاء -> قبل الفجر
    private func computeQiyamGeneral(timings: PrayerTimings, day: Date, tz: TimeZone) -> (start: Date, end: Date)? {
        guard
            let ishaSameDay = parseTime(timings.Isha, on: day, tz: tz),
            let fajrSameDay = parseTime(timings.Fajr, on: day, tz: tz)
        else { return nil }

        let fajr = fajrSameDay < ishaSameDay
        ? Calendar.current.date(byAdding: .day, value: 1, to: fajrSameDay)!
        : fajrSameDay

        let start = addMinutes(ishaSameDay, qiyamAfterIshaMinutes)
        let end = addMinutes(fajr, -endBufferBeforeFajrMinutes)
        guard end > start else { return nil }
        return (start, end)
    }

    /// ✅ تهجد رمضان (ثلث أخير): المغرب -> الفجر
    private func computeTahajjudRamadanLastThird(timings: PrayerTimings, day: Date, tz: TimeZone) -> (start: Date, end: Date)? {
        guard
            let maghrib = parseTime(timings.Maghrib, on: day, tz: tz),
            let fajrSameDay = parseTime(timings.Fajr, on: day, tz: tz)
        else { return nil }

        let fajr = fajrSameDay < maghrib
        ? Calendar.current.date(byAdding: .day, value: 1, to: fajrSameDay)!
        : fajrSameDay

        let nightSeconds = fajr.timeIntervalSince(maghrib)
        guard nightSeconds > 0 else { return nil }

        let start = maghrib.addingTimeInterval(nightSeconds * (2.0/3.0))
        let end = addMinutes(fajr, -endBufferBeforeFajrMinutes)
        guard end > start else { return nil }
        return (start, end)
    }

    // MARK: - Helpers

    private func parseTime(_ time: String, on day: Date, tz: TimeZone) -> Date? {
        let clean = time.split(separator: " ").first.map(String.init) ?? time

        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = tz
        df.dateFormat = "HH:mm"

        guard let onlyTime = df.date(from: clean) else { return nil }

        let cal = Calendar.current
        var comp = cal.dateComponents(in: tz, from: day)
        let tComp = cal.dateComponents(in: tz, from: onlyTime)
        comp.hour = tComp.hour
        comp.minute = tComp.minute
        comp.second = 0
        return cal.date(from: comp)
    }

    private func addMinutes(_ date: Date, _ minutes: Int) -> Date {
        Calendar.current.date(byAdding: .minute, value: minutes, to: date)!
    }

    private func formatArabicTime(_ date: Date, tz: TimeZone) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ar_SA")
        df.timeZone = tz
        df.dateFormat = "h:mm a"
        return df.string(from: date)
    }

    private static func statusText(_ status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "لم يتم طلب الإذن بعد"
        case .restricted: return "الموقع مقيّد"
        case .denied: return "الموقع مرفوض"
        case .authorizedAlways: return "مسموح دائمًا"
        case .authorizedWhenInUse: return "مسموح أثناء الاستخدام"
        @unknown default: return "حالة غير معروفة"
        }
    }
}
