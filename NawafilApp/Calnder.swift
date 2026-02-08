//
//  Calnder.swift
//  NawafilApp
//
import SwiftUI

struct TasbeehCalendarPage: View {
    

    // MARK: - Expandable Calendar (Week <-> Month)
   
        @Binding var count: Int
        let total: Int

        // Week (collapsed) / Month (expanded)
        enum Mode { case week, month }
        @State private var mode: Mode = .week

        // The date we're "viewing" (anchor for week/month)
        @State private var displayDate: Date = Date()
        @State private var selectedDate: Date = Date()

        // Completion store
        @State private var completion: [String: Bool] = [:]
        private let store = DailyCompletionStore()

        // Gesture
        @State private var dragY: CGFloat = 0

        var body: some View {
            VStack(spacing: 14) {

                header

                if mode == .week {
                    weekStrip
                        .transition(.opacity.combined(with: .move(edge: .top)))
                } else {
                    monthGrid
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
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
                markTodayIfCompleted()
                // نخلي البداية على اليوم الحالي
                displayDate = Date()
                selectedDate = Date()
            }
            .onChange(of: count) { _ in
                markTodayIfCompleted()
            }
            .gesture(verticalToggleGesture.simultaneously(with: horizontalPagingGesture))
            .animation(.spring(response: 0.35, dampingFraction: 0.9), value: mode)
        }

        // MARK: Header
    private var header: some View {
        HStack(spacing: 12) {

            // زر الجدول (طرف اليسار)
            Button {
                displayDate = selectedDate
                mode = (mode == .week) ? .month : .week
            } label: {
                Image(systemName: "calendar")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 44, height: 44)
            }
            .glassEffect()
            .clipShape(Circle())

            Spacer(minLength: 0)

            // مجموعة العنوان + الأسهم (بالنص والأسهم قريبة)
            HStack(spacing: 10) {

                Button { goPrevious() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 36, height: 36)
                }
               

                VStack(spacing: 2) {
                    Text(monthTitle(for: displayDate))
                        .font(.system(size: 20, weight: .semibold))
                    Text(yearTitle(for: displayDate))
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }

                Button { goNext() } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 36, height: 36)
                }
         
            }

            Spacer(minLength: 0)

            // مساحة مساوية لزر الجدول عشان العنوان يظل بالمنتصف تمامًا
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
                    isToday: Calendar.sa.isDateInToday(date)
                ) {
                    selectedDate = date
                    displayDate = date
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 120)
    }

        // MARK: Month Grid
        private var monthGrid: some View {
            let monthDays = monthGridDays(for: displayDate) // includes blanks as nil
            let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)

            return VStack(spacing: 10) {

                // أسماء الأيام (نبدأ السبت)
                HStack(spacing: 0) {
                    ForEach(["السبت","الأحد","الاثنين","الثلاثاء","الأربعاء","الخميس","الجمعة"], id: \.self) { name in
                        Text(name)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 14)

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<monthDays.count, id: \.self) { i in
                        if let date = monthDays[i] {
                            MonthCell(
                                date: date,
                                isCompleted: completion[store.dayKey(date)] == true,
                                isSelected: Calendar.sa.isDate(date, inSameDayAs: selectedDate),
                                isToday: Calendar.sa.isDateInToday(date)
                            ) {
                                selectedDate = date
                            }
                        } else {
                            Color.clear
                                .frame(height: 36)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 10)
            }
        }

        // MARK: Gestures
        private var verticalToggleGesture: some Gesture {
            DragGesture(minimumDistance: 10)
                .onChanged { value in
                    dragY = value.translation.height
                }
                .onEnded { value in
                    let h = value.translation.height
                    if h > 60 { mode = .month }     // سحب لتحت => شهر
                    if h < -60 { mode = .week }     // سحب لفوق => أسبوع
                    dragY = 0
                }
        }

        private var horizontalPagingGesture: some Gesture {
            DragGesture(minimumDistance: 15)
                .onEnded { value in
                    let w = value.translation.width
                    guard abs(w) > 50 else { return }

                    if w < 0 {
                        goNext()
                    } else {
                        goPrevious()
                    }
                }
        }

        // MARK: Navigation
        private func goNext() {
            if mode == .week {
                displayDate = Calendar.sa.date(byAdding: .day, value: 7, to: displayDate) ?? displayDate
            } else {
                displayDate = Calendar.sa.date(byAdding: .month, value: 1, to: displayDate) ?? displayDate
            }
        }

        private func goPrevious() {
            if mode == .week {
                displayDate = Calendar.sa.date(byAdding: .day, value: -7, to: displayDate) ?? displayDate
            } else {
                displayDate = Calendar.sa.date(byAdding: .month, value: -1, to: displayDate) ?? displayDate
            }
        }

        // MARK: Completion logic (لو count >= total نعلّم اليوم مكتمل)
        private func markTodayIfCompleted() {
            guard count >= total else { return }
            let todayKey = store.dayKey(Date())
            if completion[todayKey] != true {
                completion[todayKey] = true
                store.save(completion)
            }
        }

        // MARK: Date Helpers
        private func weekDates(containing date: Date) -> [Date] {
            // نجيب سبت الأسبوع الحالي (ثابت)
            let cal = Calendar.sa
            let d = cal.startOfDay(for: date)
            let weekday = cal.component(.weekday, from: d) // Sun=1 ... Sat=7
            let daysBackToSaturday = weekday % 7          // Sat->0, Sun->1, ... Fri->6
            let saturday = cal.date(byAdding: .day, value: -daysBackToSaturday, to: d) ?? d
            return (0..<7).compactMap { cal.date(byAdding: .day, value: $0, to: saturday) }
        }

        private func monthGridDays(for date: Date) -> [Date?] {
            let cal = Calendar.sa
            let start = cal.date(from: cal.dateComponents([.year, .month], from: date)) ?? date
            let range = cal.range(of: .day, in: .month, for: start) ?? 1..<31

            // اليوم الأول بالشهر
            let firstWeekday = cal.component(.weekday, from: start) // Sun=1...Sat=7
            // نبي السبت أول عمود: index 0 = Saturday
            // نحول weekday إلى offset من السبت
            let leadingBlanks = (firstWeekday) % 7 // Sat(7)->0, Sun(1)->1, ... Fri(6)->6

            var result: [Date?] = Array(repeating: nil, count: leadingBlanks)
            for day in range {
                if let d = cal.date(byAdding: .day, value: day - 1, to: start) {
                    result.append(d)
                }
            }
            return result
        }

        private func monthTitle(for d: Date) -> String {
            let f = DateFormatter()
            f.locale = Locale(identifier: "en_US_POSIX") // اسم شهر ثابت مثل المثال
            f.dateFormat = "MMMM"
            return f.string(from: d)
        }

        private func yearTitle(for d: Date) -> String {
            let f = DateFormatter()
            f.locale = Locale(identifier: "en_US_POSIX")
            f.dateFormat = "yyyy"
            return f.string(from: d)
        }
    }

    // MARK: - Week Day Pill (مثل اللي عندك لكن مع selected)
    private struct DayPill: View {
        let date: Date
        let isCompleted: Bool
        let isSelected: Bool
        let isToday: Bool
        let onTap: () -> Void

        var body: some View {
            Button(action: onTap) {
                VStack(spacing: 10) {
                    Text(dayNumber(date))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(red: 0.28, green: 0.28, blue: 0.25))
                        .frame(width: 54, height: 54)
                        .background(
                            Circle()
                                .fill(fillColor)
                        )
                        .overlay(
                            Circle().stroke(strokeColor, lineWidth: 1)
                        )

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
            if isSelected { return Color(red: 0.82, green: 0.83, blue: 0.78) } // اختيار
            if isCompleted { return Color(red: 0.82, green: 0.83, blue: 0.78) } // مكتمل
            return Color.clear
        }

        private var strokeColor: Color {
            if isToday { return Color.gray.opacity(0.5) }
            return Color.gray.opacity(0.25)
        }

        private func dayNumber(_ d: Date) -> String {
            let f = DateFormatter()
            f.locale = Locale(identifier: "ar_SA")
            f.dateFormat = "d"
            return f.string(from: d)
        }

        private func dayNameArabic(_ d: Date) -> String {
            let f = DateFormatter()
            f.locale = Locale(identifier: "ar_SA")
            f.dateFormat = "EEE" // أقصر (مثل Sun/Mon لكن عربي)
            return f.string(from: d)
        }
    }

    // MARK: - Month Cell
    private struct MonthCell: View {
        let date: Date
        let isCompleted: Bool
        let isSelected: Bool
        let isToday: Bool
        let onTap: () -> Void

        var body: some View {
            Button(action: onTap) {
                Text(dayNumber(date))
                    .font(.system(size: 14, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .foregroundColor(Color(red: 0.28, green: 0.28, blue: 0.25))
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(background)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(border, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
        }

        private var background: Color {
            if isSelected { return Color(red: 0.82, green: 0.83, blue: 0.78) }
            if isCompleted { return Color(red: 0.82, green: 0.83, blue: 0.78) }
            return Color.clear
        }

        private var border: Color {
            if isToday { return Color.gray.opacity(0.55) }
            return Color.gray.opacity(0.2)
        }

        private func dayNumber(_ d: Date) -> String {
            let f = DateFormatter()
            f.locale = Locale(identifier: "ar_SA")
            f.dateFormat = "d"
            return f.string(from: d)
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
            f.locale = Locale(identifier: "en_US_POSIX")
            f.timeZone = .current
            f.dateFormat = "yyyy-MM-dd"
            return f.string(from: date)
        }
    }

    // MARK: - Calendar preset (Saudi: week starts Saturday)
    private extension Calendar {
        static var sa: Calendar {
            var c = Calendar(identifier: .gregorian)
            // ما نعتمد على firstWeekday هنا للحسابات الأساسية، بس نخليه مضبوط احتياط
            c.firstWeekday = 7 // Saturday
            return c
        }
    }
