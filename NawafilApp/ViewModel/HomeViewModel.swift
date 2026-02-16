//
//  HomeViewModel.swift
//  NawafilApp
//
//  Created by Rana on 23/08/1447 AH.
//
import Foundation
import SwiftUI
import Combine
import WidgetKit


final class HomeViewModel: ObservableObject {

    // MARK: - UI Outputs (HomeView uses these without changing design)
    @Published var hijriDateText: String = Date().hijriUmmAlQuraString()
    @Published var timeText: String = "—"

    @Published var events: [NawafilEvent] = []
    @Published var selectedIndex: Int = 0

    // Optional (if you want later): loading/error states
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Dependencies
    private let prayerVM = PrayerTimesViewModel()

    // MARK: - Timers
    private var autoScrollCancellable: AnyCancellable?
    private var clockCancellable: AnyCancellable?
    private var eventsClockCancellable: AnyCancellable?   // ✅ NEW
    private var cancellables = Set<AnyCancellable>()

    private let fastingPreStartHour = 22 // 10 PM
    private let fastingPreStartMinute = 0

    
    // MARK: - Init
    init() {
        bindPrayerVM()
        startAutoScroll()
        startClock()
        startEventsClock()          // ✅ NEW
        updateTimeText() // initial
    }

    // MARK: - Called by HomeView.onAppear()
    func onAppear() {
        prayerVM.startLocationFlow()
    }

    deinit {
        autoScrollCancellable?.cancel()
        clockCancellable?.cancel()
        eventsClockCancellable?.cancel()   // ✅ NEW
    }

    // MARK: - Bind API VM -> Home Outputs
    private func bindPrayerVM() {

        // loading / errors (optional)
        prayerVM.$isLoading
            .receive(on: DispatchQueue.main)
            .assign(to: &$isLoading)

        prayerVM.$errorMessage
            .receive(on: DispatchQueue.main)
            .assign(to: &$errorMessage)

        // ✅ Hijri date -> UI text
        // مهم: لا نمسح تاريخ الجهاز إذا API رجعت قيمة فاضية بالبداية
        prayerVM.$hijriDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hijriDate in
                guard let self else { return }

                let trimmed = hijriDate.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return }

                self.hijriDateText = self.formatHijriText(trimmed)
                self.rebuildEvents()
            }
            .store(in: &cancellables)

        // Timings update -> rebuild events
        prayerVM.$timings
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rebuildEvents()
            }
            .store(in: &cancellables)
    }

    // MARK: - Auto Scroll (same behavior, dynamic count)
    private func startAutoScroll(interval: TimeInterval = 5) {
        autoScrollCancellable?.cancel()

        autoScrollCancellable = Timer
            .publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.moveToNext()
            }
    }

    private func moveToNext() {
        guard !events.isEmpty else { return }
        withAnimation(.easeInOut) {
            selectedIndex = (selectedIndex + 1) % events.count
        }
    }

    private func clampSelectedIndex() {
        if events.isEmpty {
            selectedIndex = 0
        } else if selectedIndex >= events.count {
            selectedIndex = max(0, events.count - 1)
        }
    }

    // MARK: - Clock (updates time label)
    private func startClock() {
        clockCancellable?.cancel()

        clockCancellable = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTimeText()
            }
    }

    private func updateTimeText() {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ar_SA")
        f.timeZone = .current
        f.dateFormat = "a h:mm"
        timeText = f.string(from: Date())
    }

    // ✅ NEW: تحديث الأحداث تلقائيًا حسب الوقت (كل دقيقة)
    private func startEventsClock() {
        eventsClockCancellable?.cancel()

        eventsClockCancellable = Timer
            .publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.rebuildEvents()
            }
    }

    // MARK: - Hijri formatter (يعالج "10-01-1447" أو نص جاهز)
    private func formatHijriText(_ raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "—" }

        // لو النص جاهز مثل: "١٠ محرم ١٤٤٧" نعرضه كما هو
        if trimmed.contains(" ") && !trimmed.contains("-") {
            return trimmed
        }

        // لو يرجّع: "10-01-1447"
        let parts = trimmed.split(separator: "-").map(String.init)
        guard parts.count == 3 else { return trimmed }

        let day = parts[0]
        let month = parts[1]
        let year = parts[2]
        return "\(day) \(hijriMonthName(from: month)) \(year)"
    }

    private func hijriMonthName(from month: String) -> String {
        switch month {
        case "01": return "محرم"
        case "02": return "صفر"
        case "03": return "ربيع الأول"
        case "04": return "ربيع الآخر"
        case "05": return "جمادى الأولى"
        case "06": return "جمادى الآخرة"
        case "07": return "رجب"
        case "08": return "شعبان"
        case "09": return "رمضان"
        case "10": return "شوال"
        case "11": return "ذو القعدة"
        case "12": return "ذو الحجة"
        default: return ""
        }
    }
    
    
        private enum FastingKind {
            case arafah
            case ashura9
            case ashura10
            case whiteDay(Int)
            case monday
            case thursday

            var title: String {
                switch self {
                case .arafah:
                    return "صيام عرفة"

                case .ashura9:
                    return "صيام تاسوعاء"

                case .ashura10:
                    return "صيام عاشوراء"

                case .whiteDay(let d):
                    return "صيام الأيام البيض (\(d))"

                case .monday:
                    return "صيام الاثنين"

                case .thursday:
                    return "صيام الخميس"
                }
            }

            var icon: String { "leaf.fill" }
        }


    private func hijriDMY(from hijri: String) -> (day: Int, month: Int, year: Int)? {
        let parts = hijri.split(separator: "-").map(String.init) // "10-01-1447"
        guard parts.count == 3,
              let d = Int(parts[0]),
              let m = Int(parts[1]),
              let y = Int(parts[2]) else { return nil }
        return (d, m, y)
    }
    
    
    private func isRamadan(_ hijri: String) -> Bool {
        guard let h = hijriDMY(from: hijri) else { return false }
        return h.month == 9
    }

    private func isLastTenOfRamadan(_ hijri: String) -> Bool {
        guard let h = hijriDMY(from: hijri) else { return false }
        return h.month == 9 && h.day >= 21
    }

    // إذا Isha رجع 00:xx نخليه تابع لليوم التالي (لأن 00:xx يعتبر بعد منتصف الليل)
    private func normalizeIsha(_ isha: Date, maghrib: Date) -> Date {
        let cal = Calendar.current
        return (isha < maghrib) ? cal.date(byAdding: .day, value: 1, to: isha)! : isha
    }

    // يجيب 10م لليلة الحالية (لو الآن بعد منتصف الليل يرجع 10م أمس)
    private func tenPMForNight(now: Date, day: Date) -> Date {
        let cal = Calendar.current
        let tenToday = tenPM(of: day)
        return (now < tenToday) ? cal.date(byAdding: .day, value: -1, to: tenToday)! : tenToday
    }

    // يخلي الفجر "النهاية الصحيحة" بعد بداية الليل
    private func fajrAfter(_ start: Date, fajr: Date) -> Date {
        let cal = Calendar.current
        return (fajr <= start) ? cal.date(byAdding: .day, value: 1, to: fajr)! : fajr
    }


    // يساعدنا نطلع "10م" لليلة الحالية (لو بعد منتصف الليل يرجع أمس)
    private func tenPMForCurrentNight(now: Date, day: Date) -> Date {
        let cal = Calendar.current
        let tenPMToday = tenPM(of: day) // 10م "اليوم"
        // إذا الآن قبل 10م (مثل 1ص) نرجع 10م أمس
        return (now < tenPMToday) ? cal.date(byAdding: .day, value: -1, to: tenPMToday)! : tenPMToday
    }

    // يحوّل fajr ليكون "الفجر التالي" بالنسبة لبداية الليل
    private func fajrAfter(_ start: Date, fajrToday: Date) -> Date {
        let cal = Calendar.current
        return (fajrToday <= start) ? cal.date(byAdding: .day, value: 1, to: fajrToday)! : fajrToday
    }


    private func fastingKindForDay(gregorian date: Date, hijriString: String) -> FastingKind? {

        if let h = hijriDMY(from: hijriString) {

            // عرفة
            if h.month == 12 && h.day == 9 {
                return .arafah
            }

            // ✅ تاسوعاء
            if h.month == 1 && h.day == 9 {
                return .ashura9
            }

            // ✅ عاشوراء
            if h.month == 1 && h.day == 10 {
                return .ashura10
            }

            // الأيام البيض
            if (13...15).contains(h.day) {
                return .whiteDay(h.day)
            }
        }

        let wd = Calendar.current.component(.weekday, from: date)
        if wd == 2 { return .monday }
        if wd == 5 { return .thursday }

        return nil
    }


    private func tenPM(of date: Date) -> Date {
        let cal = Calendar.current
        let startOfDay = cal.startOfDay(for: date)
        return cal.date(bySettingHour: fastingPreStartHour,
                        minute: fastingPreStartMinute,
                        second: 0,
                        of: startOfDay)!
    }

    // MARK: - Events Logic (based on API timings)
    private func rebuildEvents() {
        guard let t = prayerVM.timings else {
            setEvents([])
            return
        }

        let now = Date()
        let tz = TimeZone.current
        let day = Date()
        let cal = Calendar.current

        // Parse once
        let fajr = parseTime(t.Fajr, on: day, tz: tz)
        let sunrise = parseTime(t.Sunrise, on: day, tz: tz)
        let dhuhr = parseTime(t.Dhuhr, on: day, tz: tz)
        let asr = parseTime(t.Asr, on: day, tz: tz)
        let isha = parseTime(t.Isha, on: day, tz: tz)
        let maghrib = parseTime(t.Maghrib, on: day, tz: tz)

        var list: [NawafilEvent] = []

        // ✅ أذكار الصباح: من الفجر إلى 11:00 صباحًا
        if let fajr {
            let endMorningAdhkar = cal.date(bySettingHour: 11, minute: 0, second: 0, of: day)!
            if now >= fajr, now < endMorningAdhkar {
                list.append(.init(top: "يحدث الآن", title: "أذكار الصباح", icon: "sun.max.fill"))
            }
        }

        // ✅ صلاة الضحى: من بعد الشروق بـ 20 دقيقة → قبل الظهر بـ 10 دقائق
        if let sunrise, let dhuhr {
            let startDuha = cal.date(byAdding: .minute, value: 20, to: sunrise)!
            let endDuha   = cal.date(byAdding: .minute, value: -10, to: dhuhr)!
            if now >= startDuha, now < endDuha {
                list.append(.init(top: "يحدث الآن", title: "صلاة الضحى", icon: "sunrise.fill"))
            }
        }

        // ✅ أذكار المساء: من العصر إلى العشاء
        if let asr, let isha, now >= asr, now < isha {
            list.append(.init(top: "يحدث الآن", title: "أذكار المساء", icon: "moon.stars.fill"))
        }

        // ✅ منطق الليل (رمضان: تراويح + قيام رمضان + تهجد بالعشر الأواخر) | غير رمضان: قيام الليل
        if var maghribNight = maghrib,
           let fajrToday = fajr,
           var ishaNight = isha {

            let isRamadanToday = isRamadan(prayerVM.hijriDate)
            let lastTen = isLastTenOfRamadan(prayerVM.hijriDate)

            // ✅ لو الآن بعد منتصف الليل وقبل الفجر → نستخدم عشاء "أمس" (ليلة أمس)
            if now < fajrToday {
                maghribNight = cal.date(byAdding: .day, value: -1, to: maghribNight)!
                ishaNight = cal.date(byAdding: .day, value: -1, to: ishaNight)!
            }

            // ✅ تطبيع العشاء لو كان 00:xx (عشان ما ينكسر)
            ishaNight = normalizeIsha(ishaNight, maghrib: maghribNight)

            // ✅ نافذة الليل
            // (أنتِ تبين ما يبدأ قبل 10م)
            let nightTenPM = tenPMForNight(now: now, day: day)
            let afterIsha = cal.date(byAdding: .minute, value: 15, to: ishaNight)!
            let nightStart = max(afterIsha, nightTenPM)

            // نهاية الليلة: قبل الفجر بـ 10 دقائق (الفجر "التالي" بالنسبة لبداية الليل)
            let fajrEnd = fajrAfter(nightStart, fajr: fajrToday)
            let nightEnd = cal.date(byAdding: .minute, value: -10, to: fajrEnd)!

            if nightStart < nightEnd {
                if isRamadanToday {
                    // ✅ التراويح: من بعد العشاء إلى 12:00 AM (منتصف الليل)
                    let tarawihStart = afterIsha

                    let midnightNext = cal.startOfDay(
                        for: cal.date(byAdding: .day, value: 1, to: tarawihStart)!
                    )
                    let tarawihEnd = min(midnightNext, nightEnd)

                    if now >= tarawihStart && now < tarawihEnd {
                        list.append(.init(top: "يحدث الآن", title: "صلاة التراويح", icon: "moon.stars.fill"))
                    }

                    // ✅ التهجد: فقط العشر الأواخر + الثلث الأخير
                    if lastTen {
                        let nightSeconds = nightEnd.timeIntervalSince(nightStart)
                        if nightSeconds > 0 {
                            let lastThirdStart = nightStart.addingTimeInterval(nightSeconds * (2.0/3.0))
                            if now >= lastThirdStart && now < nightEnd {
                                list.append(.init(top: "يحدث الآن", title: "صلاة التهجد", icon: "moon.fill"))
                            }                         }
                    }

                } else {
                    // ✅ غير رمضان: قيام الليل
                    if now >= nightStart && now < nightEnd {
                        list.append(.init(top: "يحدث الآن", title: "قيام الليل", icon: "moon.fill"))
                    }
                }
            }
        }

        // ✅ الصيام (ما يظهر في رمضان)
        let today = day
        let tomorrow = cal.date(byAdding: .day, value: 1, to: today)!

        let maghribToday = maghrib
        let maghribTomorrow: Date? = {
            guard let tt = prayerVM.tomorrowTimings else { return nil }
            return parseTime(tt.Maghrib, on: tomorrow, tz: tz)
        }()

        if !isRamadan(prayerVM.hijriDate) && !isRamadan(prayerVM.tomorrowHijriDate) {
            if let maghribToday {
                // (A) إذا اليوم يوم صيام: يبدأ من أمس 10م وينتهي مغرب اليوم
                if let kindToday = fastingKindForDay(gregorian: today, hijriString: prayerVM.hijriDate) {
                    let start = cal.date(byAdding: .day, value: -1, to: tenPM(of: today))!
                    let end = maghribToday
                    if now >= start && now < end {
                        list.insert(.init(top: "يحدث الآن", title: kindToday.title, icon: kindToday.icon), at: 0)
                    }
                }
                // (B) إذا اليوم مو صيام لكن بكرة صيام: يبدأ اليوم 10م وينتهي مغرب بكرة
                else if let maghribTomorrow,
                        let kindTomorrow = fastingKindForDay(gregorian: tomorrow, hijriString: prayerVM.tomorrowHijriDate),
                        !prayerVM.tomorrowHijriDate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {

                    let start = tenPM(of: today)
                    let end = maghribTomorrow
                    if now >= start && now < end {
                        list.insert(.init(top: "يحدث الآن", title: kindTomorrow.title, icon: kindTomorrow.icon), at: 0)
                    }
                }
            }
        }
        
        
        if list.isEmpty {
            let adhkar = ["سبحان الله", "الحمد لله", "استغفر الله", "الله أكبر"]
            let index = Int(now.timeIntervalSinceReferenceDate / 60) % adhkar.count

            list = [
                .init(top: "ذكر", title: adhkar[index], icon: "sparkles")
            ]
        }

        // Debug
        print("NOW:", now)
        print("Maghrib:", maghribToday as Any)
        print("Isha:", isha as Any)
        print("Fajr:", fajr as Any)
        print("tenPM(today):", tenPM(of: day))
        print("✅ events count:", list.count)
        print(list.map { $0.title })

        setEvents(list)

        let listForWidget = list.filter { $0.top == "يحدث الآن" }
        NawafilEventStore.saveEvents(listForWidget)
        WidgetCenter.shared.reloadTimelines(ofKind: "NawafilLockWidget")

    }


    private func isAshuraDay() -> Bool {
        let parts = prayerVM.hijriDate.split(separator: "-").map(String.init)
        guard parts.count == 3 else { return false }
        let day = parts[0]
        let month = parts[1]
        return (month == "01" && (day == "10" || day == "09"))
    }

    private func setEvents(_ newEvents: [NawafilEvent]) {
        events = newEvents
        clampSelectedIndex()
    }

    // MARK: - Time Parsing helper
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
}

// ✅ لازم يكون خارج الكلاس
extension Date {
    func hijriUmmAlQuraString() -> String {
        var cal = Calendar(identifier: .islamicUmmAlQura)
        cal.locale = Locale(identifier: "ar_SA")

        let f = DateFormatter()
        f.calendar = cal
        f.locale = Locale(identifier: "ar_SA")
        f.timeZone = .current
        f.dateFormat = "d MMMM yyyy"

        return f.string(from: self)
    }
    
    
    
}
