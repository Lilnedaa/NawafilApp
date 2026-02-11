//
//  HomeViewModel.swift
//  NawafilApp
//
//  Created by Rana on 23/08/1447 AH.
//
import Foundation
import SwiftUI
import Combine

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

    // MARK: - Events Logic (based on API timings)
    private func rebuildEvents() {
        guard let t = prayerVM.timings else {
            setEvents([])
            return
        }

        let now = Date()
        let tz = TimeZone.current
        let day = Date()

        let fajr = parseTime(t.Fajr, on: day, tz: tz)
        let sunrise = parseTime(t.Sunrise, on: day, tz: tz)
        let dhuhr = parseTime(t.Dhuhr, on: day, tz: tz)
        let asr = parseTime(t.Asr, on: day, tz: tz)
        let isha = parseTime(t.Isha, on: day, tz: tz)

        var list: [NawafilEvent] = []

        // أذكار الصباح: من الفجر إلى بداية الضحى (الشروق + 20 دقيقة)
        if let fajr, let sunrise {
            let dhuhaStart = Calendar.current.date(byAdding: .minute, value: 20, to: sunrise)!
            if now >= fajr, now < dhuhaStart {
                list.append(.init(top: "يحدث الآن", title: "أذكار الصباح", icon: "sun.max.fill"))
            }

            // صلاة الضحى: من (الشروق + 20 دقيقة) إلى قبل الظهر بـ 10 دقائق
            if let dhuhr {
                let dhuhaEnd = Calendar.current.date(byAdding: .minute, value: -10, to: dhuhr)!
                if now >= dhuhaStart, now < dhuhaEnd {
                    list.append(.init(top: "يحدث الآن", title: "صلاة الضحى", icon: "sparkles"))
                }
            }
        }

        // أذكار المساء: من العصر إلى العشاء
        if let asr, let isha, now >= asr, now < isha {
            list.append(.init(top: "يحدث الآن", title: "أذكار المساء", icon: "moon.stars.fill"))
        }

        // قيام الليل: من بعد العشاء إلى قبل الفجر (اليوم التالي)
        if let isha, let fajrSameDay = fajr {
            let fajrNext = fajrSameDay < isha
                ? Calendar.current.date(byAdding: .day, value: 1, to: fajrSameDay)!
                : fajrSameDay

            if now >= isha, now < fajrNext {
                list.append(.init(top: "يحدث الآن", title: "قيام الليل", icon: "moon.fill"))
            }
        }

        // عاشوراء (اختياري)
        if isAshuraDay() {
            list.insert(.init(top: "اليوم فقط", title: "صيام عاشوراء", icon: "calendar"), at: 0)
        }

        setEvents(list)
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
