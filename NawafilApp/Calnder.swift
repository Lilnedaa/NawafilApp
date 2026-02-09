//
//  Calnder.swift
//  NawafilApp
//

import SwiftUI

struct TasbeehCalendarPage: View {

    @Binding var count: Int
    let total: Int

    // أسبوع فقط بالواجهة الأساسية
    @State private var displayDate: Date = Date()
    @State private var selectedDate: Date = Date()

    @State private var completion: [String: Bool] = [:]
    private let store = DailyCompletionStore()

    // Sheet
    @State private var showMonthSheet = false

    var body: some View {
        VStack(spacing: 14) {

            header

            weekStrip
                .transition(.opacity.combined(with: .move(edge: .top)))
        }
        .environment(\.layoutDirection, .rightToLeft)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(Color.white.opacity(0.35))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 26)
                .stroke(Color.white.opacity(0.8), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 12, y: 8)
        .padding(.horizontal, 16)
        .onAppear {
            completion = store.load()
            displayDate = Date()
            selectedDate = Date()
            markSelectedIfCompleted()
        }
        .onChange(of: count) { _ in
            markSelectedIfCompleted()
        }
        .gesture(horizontalWeekPagingGesture)
        .sheet(isPresented: $showMonthSheet) {
            MonthSheet(
                displayDate: $displayDate,
                selectedDate: $selectedDate,
                completion: $completion,
                store: store,
                onSelectDate: {
                    // بعد اختيار يوم من الشهر: نغلق الشيت ونرجع للأسبوع الموافق
                    showMonthSheet = false
                    displayDate = selectedDate
                    markSelectedIfCompleted()
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }

    // MARK: Header (زر الكالندر يفتح شيت)
    private var header: some View {
        HStack(spacing: 12) {

            Button {
                // ✅ افتح الشيت بدل ما يتوسع داخل الواجهة
                showMonthSheet = true
            } label: {
                Image(systemName: "calendar")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 44, height: 44)
            }
            .glassEffect()
            .clipShape(Circle())

            Spacer(minLength: 0)

            HStack(spacing: 10) {

                Button { goPreviousWeek() } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 36, height: 36)
                }

                VStack(spacing: 3) {
                    Text(hijriMonthYearTitle(for: displayDate))
                        .font(.system(size: 16, weight: .semibold))

                    Text(gregMonthYearTitle(for: displayDate))
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }

                Button { goNextWeek() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 36, height: 36)
                }
            }

            Spacer(minLength: 0)

            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 12)
    }

    // MARK: Week Strip
    private var weekStrip: some View {
        let days = weekDates(containing: displayDate)

        return HStack(spacing: 14) {
            ForEach(days, id: \.self) { date in
                DayPill(
                    date: date,
                    isCompleted: completion[store.dayKey(date)] == true,
                    isSelected: Calendar.sa.isDate(date, inSameDayAs: selectedDate),
                    isToday: Calendar.sa.isDateInToday(date),
                    gregDayText: gregDayNumber(date),
                    hijriDayText: hijriDayNumber(date)
                ) {
                    selectedDate = date
                    displayDate = date
                    markSelectedIfCompleted()
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 120)
    }

    // MARK: Gesture (سحب يمين/يسار للتنقل بين الأسابيع)
    private var horizontalWeekPagingGesture: some Gesture {
        DragGesture(minimumDistance: 15)
            .onEnded { value in
                let w = value.translation.width
                guard abs(w) > 50 else { return }

                if w < 0 {
                    goNextWeek()
                } else {
                    goPreviousWeek()
                }
            }
    }

    // MARK: Navigation (Week only)
    private func goNextWeek() {
        displayDate = Calendar.sa.date(byAdding: .day, value: 7, to: displayDate) ?? displayDate
    }

    private func goPreviousWeek() {
        displayDate = Calendar.sa.date(byAdding: .day, value: -7, to: displayDate) ?? displayDate
    }

    // MARK: Completion (يسجل لليوم المختار)
    private func markSelectedIfCompleted() {
        guard count >= total else { return }
        let key = store.dayKey(selectedDate)
        if completion[key] != true {
            completion[key] = true
            store.save(completion)
        }
    }

    // MARK: Date Helpers
    private func weekDates(containing date: Date) -> [Date] {
        let cal = Calendar.sa
        let d = cal.startOfDay(for: date)
        let weekday = cal.component(.weekday, from: d) // Sun=1 ... Sat=7
        let daysBackToSaturday = weekday % 7          // Sat->0, Sun->1, ... Fri->6
        let saturday = cal.date(byAdding: .day, value: -daysBackToSaturday, to: d) ?? d
        return (0..<7).compactMap { cal.date(byAdding: .day, value: $0, to: saturday) }
    }

    private func gregDayNumber(_ d: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar.sa
        f.locale = Locale(identifier: "ar_SA")
        f.dateFormat = "d"
        return f.string(from: d)
    }

    private func hijriDayNumber(_ d: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar.hijriSA
        f.locale = Locale(identifier: "ar_SA")
        f.dateFormat = "d"
        return f.string(from: d)
    }

    private func hijriMonthYearTitle(for d: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar.hijriSA
        f.locale = Locale(identifier: "ar_SA")
        f.dateFormat = "MMMM yyyy"
        return f.string(from: d) + " هـ"
    }

    private func gregMonthYearTitle(for d: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar.sa
        f.locale = Locale(identifier: "ar_SA")
        f.dateFormat = "MMMM yyyy"
        return f.string(from: d)
    }
}

// MARK: - Month Sheet
private struct MonthSheet: View {
    @Binding var displayDate: Date
    @Binding var selectedDate: Date
    @Binding var completion: [String: Bool]

    let store: DailyCompletionStore
    let onSelectDate: () -> Void

    // الشهر المعروض داخل الشيت (نخليه مستقل عشان تنقل الأشهر)
    @State private var sheetMonthDate: Date = Date()

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)

    var body: some View {
        VStack(spacing: 14) {

            // Header داخل الشيت (شهر هجري + ميلادي)
            HStack(spacing: 10) {

                Button { goPreviousMonth() } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 36, height: 36)
                }

                VStack(spacing: 3) {
                    Text(hijriMonthYearTitle(for: sheetMonthDate))
                        .font(.system(size: 16, weight: .semibold))
                    Text(gregMonthYearTitle(for: sheetMonthDate))
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }

                Button { goNextMonth() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 36, height: 36)
                }

                Spacer()

                Button("تم") {
                    // يرجع للأسبوع الحالي المختار
                    onSelectDate()
                }
                .font(.system(size: 14, weight: .semibold))
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            // أسماء الأيام
            HStack(spacing: 0) {
                ForEach(["السبت","الأحد","الاثنين","الثلاثاء","الأربعاء","الخميس","الجمعة"], id: \.self) { name in
                    Text(name)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 16)

            // Grid ثابت 42 خانة (6 صفوف)
            let days = monthGridDaysFixed42(for: sheetMonthDate)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<days.count, id: \.self) { i in
                    if let date = days[i] {
                        MonthCircleCell(
                            date: date,
                            isCompleted: completion[store.dayKey(date)] == true,
                            isSelected: Calendar.sa.isDate(date, inSameDayAs: selectedDate),
                            isToday: Calendar.sa.isDateInToday(date),
                            gregDayText: gregDayNumber(date),
                            hijriDayText: hijriDayNumber(date)
                        ) {
                            selectedDate = date
                            displayDate = date
                            onSelectDate()
                        }
                    } else {
                        Color.clear
                            .frame(width: 44, height: 44)
                    }
                }
            }
            .padding(.horizontal, 16)

            Spacer(minLength: 8)
        }
        .environment(\.layoutDirection, .rightToLeft)
        .onAppear {
            sheetMonthDate = displayDate
        }
    }

    // MARK: Month navigation in sheet
    private func goNextMonth() {
        sheetMonthDate = Calendar.sa.date(byAdding: .month, value: 1, to: sheetMonthDate) ?? sheetMonthDate
    }

    private func goPreviousMonth() {
        sheetMonthDate = Calendar.sa.date(byAdding: .month, value: -1, to: sheetMonthDate) ?? sheetMonthDate
    }

    // MARK: Fixed 42 cells
    private func monthGridDaysFixed42(for date: Date) -> [Date?] {
        let cal = Calendar.sa
        let start = cal.date(from: cal.dateComponents([.year, .month], from: date)) ?? date
        let range = cal.range(of: .day, in: .month, for: start) ?? 1..<31

        let firstWeekday = cal.component(.weekday, from: start) // Sun=1...Sat=7
        let leadingBlanks = (firstWeekday) % 7                  // Saturday first

        var result: [Date?] = Array(repeating: nil, count: leadingBlanks)

        for day in range {
            if let d = cal.date(byAdding: .day, value: day - 1, to: start) {
                result.append(d)
            }
        }

        if result.count < 42 {
            result.append(contentsOf: Array(repeating: nil, count: 42 - result.count))
        } else if result.count > 42 {
            result = Array(result.prefix(42))
        }
        return result
    }

    // MARK: Formatting
    private func gregDayNumber(_ d: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar.sa
        f.locale = Locale(identifier: "ar_SA")
        f.dateFormat = "d"
        return f.string(from: d)
    }

    private func hijriDayNumber(_ d: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar.hijriSA
        f.locale = Locale(identifier: "ar_SA")
        f.dateFormat = "d"
        return f.string(from: d)
    }

    private func hijriMonthYearTitle(for d: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar.hijriSA
        f.locale = Locale(identifier: "ar_SA")
        f.dateFormat = "MMMM yyyy"
        return f.string(from: d) + " هـ"
    }

    private func gregMonthYearTitle(for d: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar.sa
        f.locale = Locale(identifier: "ar_SA")
        f.dateFormat = "MMMM yyyy"
        return f.string(from: d)
    }
}

// MARK: - Week Day Pill
private struct DayPill: View {
    let date: Date
    let isCompleted: Bool
    let isSelected: Bool
    let isToday: Bool
    let gregDayText: String
    let hijriDayText: String
    let onTap: () -> Void

    private let doneGreen = Color(red: 0.07, green: 0.45, blue: 0.22)

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 10) {

                VStack(spacing: 2) {
                    Text(hijriDayText) // هجري كبير
                        .font(.system(size: 22, weight: .bold))
                    Text(gregDayText)  // ميلادي صغير
                        .font(.system(size: 11, weight: .semibold))
                        .opacity(0.7)
                }
                .foregroundColor(textColor)
                .frame(width: 54, height: 54)
                .background(Circle().fill(fillColor))
                .overlay(Circle().stroke(strokeColor, lineWidth: 1))

                Text(dayNameArabic(date))
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.28, green: 0.28, blue: 0.25))
            }
            .frame(width: 88, height: 120)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.white.opacity(0.35))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.white.opacity(0.8), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.06), radius: 10, y: 6)
        }
        .buttonStyle(.plain)
    }

    private var fillColor: Color {
        if isCompleted { return doneGreen }
        if isSelected { return Color(red: 0.82, green: 0.83, blue: 0.78) }
        return Color.clear
    }

    private var textColor: Color {
        if isCompleted { return .white }
        return Color(red: 0.28, green: 0.28, blue: 0.25)
    }

    private var strokeColor: Color {
        if isToday { return Color.gray.opacity(0.5) }
        return Color.gray.opacity(0.25)
    }

    private func dayNameArabic(_ d: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar.sa
        f.locale = Locale(identifier: "ar_SA")
        f.dateFormat = "EEE"
        return f.string(from: d)
    }
}

// MARK: - Month Circle Cell (مثل روح الأسبوع لكن أصغر)
private struct MonthCircleCell: View {
    let date: Date
    let isCompleted: Bool
    let isSelected: Bool
    let isToday: Bool
    let gregDayText: String
    let hijriDayText: String
    let onTap: () -> Void

    private let doneGreen = Color(red: 0.07, green: 0.45, blue: 0.22)

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text(hijriDayText)
                    .font(.system(size: 14, weight: .bold))
                Text(gregDayText)
                    .font(.system(size: 10, weight: .semibold))
                    .opacity(0.75)
            }
            .foregroundColor(textColor)
            .frame(width: 44, height: 44)
            .background(Circle().fill(fillColor))
            .overlay(Circle().stroke(strokeColor, lineWidth: 1))
            .shadow(color: .black.opacity(0.04), radius: 6, y: 4)
        }
        .buttonStyle(.plain)
    }

    private var fillColor: Color {
        if isCompleted { return doneGreen }
        if isSelected { return Color(red: 0.82, green: 0.83, blue: 0.78) }
        return Color.white.opacity(0.20)
    }

    private var textColor: Color {
        if isCompleted { return .white }
        return Color(red: 0.28, green: 0.28, blue: 0.25)
    }

    private var strokeColor: Color {
        if isToday { return Color.gray.opacity(0.55) }
        return Color.white.opacity(0.8)
    }
}

// MARK: - Storage
private struct DailyCompletionStore {
    private let key = "tasbeeh_daily_completion_v1"

    func load() -> [String: Bool] {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let dict = try? JSONDecoder().decode([String: Bool].self, from: data)
        else { return [:] }
        return dict
    }

    func save(_ dict: [String: Bool]) {
        if let data = try? JSONEncoder().encode(dict) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func dayKey(_ date: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar.sa
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }
}

// MARK: - Calendars
private extension Calendar {
    static var sa: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.locale = Locale(identifier: "ar_SA")
        c.timeZone = .current
        c.firstWeekday = 7
        return c
    }

    static var hijriSA: Calendar {
        var c = Calendar(identifier: .islamicUmmAlQura)
        c.locale = Locale(identifier: "ar_SA")
        c.timeZone = .current
        c.firstWeekday = 7
        return c
    }
}
