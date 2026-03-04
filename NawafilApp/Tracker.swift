//
//  Tracker.swift
//  NawafilApp
//
//  Created by Shaikha Alnashri on 20/08/1447 AH.
//

import SwiftUI

private func encodeStringArray(_ arr: [String]) -> String {
    let data = (try? JSONEncoder().encode(arr)) ?? Data()
    return String(data: data, encoding: .utf8) ?? "[]"
}

private func decodeStringArray(_ str: String) -> [String] {
    guard let data = str.data(using: .utf8),
          let arr = try? JSONDecoder().decode([String].self, from: data) else { return [] }
    return arr
}

struct Tracker: View {
    @AppStorage("savedWorshipsJSON") private var savedWorshipsJSON: String = "[]"
    var savedWorships: [String] { decodeStringArray(savedWorshipsJSON) }

    var body: some View {
        NavigationStack {
            Group {
                if savedWorships.isEmpty {
                    WorshipSelectionView()
                } else {
                    WorshipTrackerView(selectedWorships: savedWorships)
                }
            }
        }
    }
}

struct WorshipSelectionView: View {
    @State private var selectedWorships: Set<String> = []
    @State private var navigateToTracker = false

    @AppStorage("savedWorshipsJSON") private var savedWorshipsJSON: String = "[]"

    let defaultWorships = [
        "قراءة القرآن",
        "أذكار الصباح",
        "أذكار المساء",
        "قيام الليل",
        "صلاة الضحى"
    ]

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            VStack(spacing: 40) {

                VStack(alignment: .leading, spacing: 18) {
                    Text("اختر النوافل")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(textColor)

                    Text("حدد النوافل التي تريد الاستمرار عليها")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(textColor.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 60)
                .padding(.horizontal, 40)

                Spacer()

                FlowLayout(spacing: 12) {
                    ForEach(defaultWorships, id: \.self) { worship in
                        CapsuleButton(
                            title: worship,
                            isSelected: selectedWorships.contains(worship)
                        ) {
                            if selectedWorships.contains(worship) {
                                selectedWorships.remove(worship)
                            } else {
                                selectedWorships.insert(worship)
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 100)

                Spacer()

                Button {
                    guard !selectedWorships.isEmpty else { return }
                    let arr = Array(selectedWorships)
                    savedWorshipsJSON = encodeStringArray(arr)
                    navigateToTracker = true
                } label: {
                    Text("متابعة")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 190, height: 60)
                        .background(selectedWorships.isEmpty ? Color.gray.opacity(0.4) : buttonColor)
                        .cornerRadius(30)
                        .glassEffect()
                }
                .disabled(selectedWorships.isEmpty)
                .padding(.horizontal, 40)
                .padding(.bottom, 150)
            }
            .navigationDestination(isPresented: $navigateToTracker) {
                WorshipTrackerView(selectedWorships: decodeStringArray(savedWorshipsJSON))
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// Capsule Button
struct CapsuleButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? .white : textColor)

                if isSelected {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.6))
                            .frame(width: 24, height: 24)
                        Circle()
                            .stroke(Color.white.opacity(0.8), lineWidth: 2)
                            .frame(width: 24, height: 24)
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(buttonColor)
                    }
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(Capsule().fill(isSelected ? buttonColor.opacity(0.85) : Color.white.opacity(0.3)))
            .overlay(Capsule().stroke(isSelected ? Color.white.opacity(0.5) : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1.5))
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 10

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(
                at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y),
                proposal: .unspecified
            )
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let s = subview.sizeThatFits(.unspecified)
                if x + s.width > maxWidth * 1.1 && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, s.height)
                x += s.width + spacing
            }
            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

struct WorshipTrackerView: View {
    @State private var selectedWorships: [String]
    @State private var fireAnimation: Bool = false
    @State private var showAddSheet = false
    @State private var tempSelectedWorships: Set<String> = []

    @AppStorage("checkedTodayJSON")        private var checkedTodayJSON: String = "[]"
    @AppStorage("lastResetDay")            private var lastResetDay: Double = 0
    @AppStorage("lastFullCompletionTime")  private var lastFullCompletionTime: Double = 0
    @AppStorage("lastStreakIncrementTime") private var lastStreakIncrementTime: Double = 0
    @AppStorage("streakCount")            private var streakCount: Int = 0
    @AppStorage("savedWorshipsJSON")      private var savedWorshipsJSON: String = "[]"

    @Environment(\.scenePhase) private var scenePhase

    private var checkedToday: Set<String> {
        Set(decodeStringArray(checkedTodayJSON))
    }
    private func saveChecked(_ set: Set<String>) {
        checkedTodayJSON = encodeStringArray(Array(set))
    }

    let defaultWorships = [
        "قراءة القرآن",
        "أذكار الصباح",
        "أذكار المساء",
        "قيام الليل",
        "صلاة الضحى"
    ]

    init(selectedWorships: [String]) {
        _selectedWorships = State(initialValue: selectedWorships)
    }

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            VStack {
                ZStack {
                    Text("متابعة النوافل")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(textColor)

                    HStack {
                        Spacer()
                        Button {
                            tempSelectedWorships = Set(selectedWorships)
                            showAddSheet = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Color(textColor))
                                .frame(width: 44, height: 44)
                                .glassEffect(.regular.tint(.clear).interactive(), in: Circle())
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)

                ScrollView {
                    VStack(spacing: 60) {

                        // streak
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 15)
                                .frame(width: 250, height: 250)

                            VStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(buttonColor)
                                    .scaleEffect(fireAnimation ? 1.3 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: fireAnimation)

                                Text("\(streakCount)")
                                    .font(.system(size: 65, weight: .bold))
                                    .foregroundColor(buttonColor)

                                Text("يوم")
                                    .font(.system(size: 30, weight: .medium))
                                    .foregroundColor(textColor)
                            }
                        }
                        .padding(.top, 20)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 18) {
                            ForEach(selectedWorships, id: \.self) { worship in
                                WorshipProgressCard(
                                    worshipName: worship,
                                    isChecked: checkedToday.contains(worship),
                                    onToggle: { toggleCheck(for: worship) }
                                )
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddWorshipSheet(
                selectedWorships: $tempSelectedWorships,
                defaultWorships: defaultWorships,
                onSave: {
                    let previousWorships = Set(selectedWorships)
                    let newlyAdded = tempSelectedWorships.subtracting(previousWorships)
                    let removed = previousWorships.subtracting(tempSelectedWorships)

                    for worship in removed {
                        UserDefaults.standard.removeObject(forKey: "count_\(worship)")
                        UserDefaults.standard.removeObject(forKey: "lastTap_\(worship)")
                    }

                    if tempSelectedWorships.isEmpty {
                        savedWorshipsJSON = "[]"
                        selectedWorships = []
                        saveChecked([])
                        streakCount = 0
                        lastFullCompletionTime = 0
                        lastStreakIncrementTime = 0
                        showAddSheet = false
                        return
                    }

                    selectedWorships = Array(tempSelectedWorships)
                    let filtered = checkedToday.filter { tempSelectedWorships.contains($0) }
                    saveChecked(filtered)
                    savedWorshipsJSON = encodeStringArray(selectedWorships)

                    let hadOnlyRemovedOnes = previousWorships == removed
                    if hadOnlyRemovedOnes && !newlyAdded.isEmpty {
                        streakCount = 0
                        lastFullCompletionTime = 0
                        lastStreakIncrementTime = 0
                    }

                    showAddSheet = false
                }
            )
        }
        .onAppear {
            validateAndResetIfNeeded()
            if lastResetDay == 0 { lastResetDay = startOfTodayTimeInterval() }
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active { validateAndResetIfNeeded() }
        }
        .navigationBarBackButtonHidden(true)
        .environment(\.layoutDirection, .rightToLeft)
    }

    // MARK: - Helpers

    private func startOfTodayTimeInterval() -> Double {
        Calendar.current.startOfDay(for: Date()).timeIntervalSince1970
    }

    private func validateAndResetIfNeeded() {
        let now = Date().timeIntervalSince1970
        let today = startOfTodayTimeInterval()

        if lastResetDay != today {
            lastResetDay = today
            saveChecked([])

            for worship in selectedWorships {
                let countKey = "count_\(worship)"
                if UserDefaults.standard.integer(forKey: countKey) >= 30 {
                    UserDefaults.standard.set(0, forKey: countKey)
                }
            }

            if lastFullCompletionTime > 0 {
                let daysSinceCompletion = (now - lastFullCompletionTime) / (24.0 * 3600.0)
                if daysSinceCompletion > 2.0 { resetStreak() }
            } else {
                resetStreak()
            }
        }
    }

    private func resetStreak() {
        streakCount = 0
        saveChecked([])
        lastFullCompletionTime = 0
        lastStreakIncrementTime = 0
    }

    private func streakWasIncrementedToday() -> Bool {
        guard lastStreakIncrementTime > 0 else { return false }
        let today = startOfTodayTimeInterval()
        let incrementDay = Calendar.current.startOfDay(
            for: Date(timeIntervalSince1970: lastStreakIncrementTime)
        ).timeIntervalSince1970
        return incrementDay == today
    }

    private func toggleCheck(for worship: String) {
        validateAndResetIfNeeded()

        guard !checkedToday.contains(worship) else { return }

        var updated = checkedToday
        updated.insert(worship)
        saveChecked(updated)

        incrementSingleWorshipCountOncePerDay(for: worship)

        guard updated.count == selectedWorships.count else { return }

        guard !streakWasIncrementedToday() else { return }

        let now = Date().timeIntervalSince1970
        lastFullCompletionTime = now
        lastStreakIncrementTime = now

        streakCount += 1
        fireAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            fireAnimation = false
        }
    }

    private func incrementSingleWorshipCountOncePerDay(for worship: String) {
        let today = startOfTodayTimeInterval()
        let lastTapKey = "lastTap_\(worship)"
        let countKey   = "count_\(worship)"

        let lastTapDay = UserDefaults.standard.double(forKey: lastTapKey)
        guard lastTapDay != today else { return }

        var currentCount = UserDefaults.standard.integer(forKey: countKey)
        if currentCount >= 30 { currentCount = 0 }
        UserDefaults.standard.set(currentCount + 1, forKey: countKey)
        UserDefaults.standard.set(today, forKey: lastTapKey)
    }
}

struct AddWorshipSheet: View {
    @Binding var selectedWorships: Set<String>
    let defaultWorships: [String]
    let onSave: () -> Void

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            VStack(spacing: 20) {

                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(textColor)
                            .frame(width: 44, height: 44)
                            .glassEffect(.regular.tint(.clear).interactive(), in: Circle())
                    }

                    Spacer()

                    Button {
                        onSave()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(buttonColor))
                            .frame(width: 44, height: 44)
                            .glassEffect(.regular.tint(.clear).interactive(), in: Circle())
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 18) {
                    Text("اختر النوافل")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(textColor)

                    Text("حدد النوافل التي تريد الاستمرار عليها")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(textColor.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 40)
                .padding(.top, 30)

                Spacer().frame(height: 10)

                FlowLayout(spacing: 12) {
                    ForEach(defaultWorships, id: \.self) { worship in
                        CapsuleButton(
                            title: worship,
                            isSelected: selectedWorships.contains(worship)
                        ) {
                            if selectedWorships.contains(worship) {
                                selectedWorships.remove(worship)
                            } else {
                                selectedWorships.insert(worship)
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)

                Spacer()
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

struct WorshipProgressCard: View {
    let worshipName: String
    let isChecked: Bool
    let onToggle: () -> Void

    @AppStorage var individualCount: Int

    init(worshipName: String, isChecked: Bool, onToggle: @escaping () -> Void) {
        self.worshipName = worshipName
        self.isChecked = isChecked
        self.onToggle = onToggle
        self._individualCount = AppStorage(wrappedValue: 0, "count_\(worshipName)")
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(worshipName)
                .font(.system(size: 21, weight: .semibold))
                .foregroundColor(textColor)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.top, 15)
                .padding(.horizontal, 10)

            Spacer()

            HStack(spacing: 0) {
                Button { onToggle() } label: {
                    ZStack {
                        if isChecked {
                            Circle()
                                .fill(buttonColor)
                                .frame(width: 35, height: 35)
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        } else {
                            Circle()
                                .stroke(Color.gray.opacity(0.6), lineWidth: 2)
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                .padding(.leading, 15)
                .padding(.top, 30)

                Spacer()

                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.15), lineWidth: 6)
                        .frame(width: 80, height: 80)

                    if individualCount > 0 {
                        Circle()
                            .trim(from: 0, to: CGFloat(individualCount) / 30.0)
                            .stroke(buttonColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-270))
                            .animation(.easeInOut(duration: 0.3), value: individualCount)
                    }

                    Text("\(individualCount)/30")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(textColor)
                }
                .padding(.trailing, 15)
            }

            Spacer()
        }
        .frame(width: 165, height: 165)
        .background(RoundedRectangle(cornerRadius: 22).fill(Color.white.opacity(0.4)))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.white.opacity(0.5), lineWidth: 1.5))
    }
}

#Preview {
    Tracker()
}
