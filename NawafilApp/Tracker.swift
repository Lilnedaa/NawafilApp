//
//  Tracker.swift
//  NawafilApp
//
//  Created by Shaikha Alnashri on 20/08/1447 AH.
//

import SwiftUI


struct Tracker: View {
    @State private var selectedWorships: Set<String> = []
    @State private var navigateToTracker = false
    
    let defaultWorships = [
        "قراءة القرآن",
        "أذكار الصباح",
        "أذكار المساء",
        "قيام الليل",
        "صلاة الضحى"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
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
                    
                    VStack(spacing: 15) {
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
                        .padding(.bottom, 160)
                    }
                    
                    Spacer()
                    
                    Button {
                        if !selectedWorships.isEmpty {
                            navigateToTracker = true
                        }
                    } label: {
                        Text("متابعة")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(
                                selectedWorships.isEmpty
                                    ? Color.gray.opacity(0.4)
                                    : buttonColor
                            )
                            .cornerRadius(30)
                            .glassEffect()
                    }
                    .disabled(selectedWorships.isEmpty)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
                .navigationDestination(isPresented: $navigateToTracker) {
                    WorshipTrackerView(selectedWorships: Array(selectedWorships))
                }
            }
            .environment(\.layoutDirection, .rightToLeft)
        }
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
            .background(
                Capsule()
                    .fill(isSelected ? buttonColor.opacity(0.85) : Color.white.opacity(0.3))
            )
            .overlay(
                Capsule()
                    .stroke(
                        isSelected ? Color.white.opacity(0.5) : Color.gray.opacity(0.3),
                        lineWidth: isSelected ? 2 : 1.5
                    )
            )
        }
    }
}


struct FlowLayout: Layout {
    var spacing: CGFloat = 10
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                     y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
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
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth * 1.1 && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

// MARK: - Tracker View

struct WorshipTrackerView: View {
    let selectedWorships: [String]
    
    @State private var checkedToday: Set<String> = []
    @State private var fireAnimation: Bool = false
    
    @AppStorage("lastResetDay") private var lastResetDay: Double = 0
    @AppStorage("lastCheckTime") private var lastCheckTime: Double = 0
    @AppStorage("streakCount") private var streakCount: Int = 0
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack {

                HStack {
                    Spacer()
                    
                    Text("متابعة النوافل")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(textColor)
                    
                    Spacer()
                    
                    Button {

                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(Color(buttonColor))
                            .frame(width: 40, height: 40)
                    }
                    .glassEffect()
                    .clipShape(Circle())
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 60) {
                        
                        VStack(spacing: 12) {
                            ZStack {
                                ProgressRing(total: 30, count: streakCount, size: 250)
                                
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
                        }
                        .padding(.top, 20)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 18) {
                            ForEach(selectedWorships, id: \.self) { worship in
                                WorshipProgressCard(
                                    worshipName: worship,
                                    isChecked: checkedToday.contains(worship),
                                    onToggle: {
                                        toggleCheck(for: worship)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .onAppear {

            resetStreak()
            let today = startOfTodayTimeInterval()
            lastResetDay = today
        }
        .onChange(of: scenePhase) { _, newValue in
            if newValue == .active {
                checkStreakValidity()
                resetIfNewDay()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func startOfTodayTimeInterval() -> Double {
        let start = Calendar.current.startOfDay(for: Date())
        return start.timeIntervalSince1970
    }
    
    private func checkStreakValidity() {
        let now = Date().timeIntervalSince1970
        let hoursSinceLastCheck = (now - lastCheckTime) / 3600
        
        if lastCheckTime > 0 && hoursSinceLastCheck >= 42 {
            resetStreak()
        }
    }
    
    private func resetStreak() {
        streakCount = 0
        checkedToday.removeAll()
    }
    
    private func resetIfNewDay() {
        let today = startOfTodayTimeInterval()
        
        if lastResetDay == 0 {
            lastResetDay = today
            checkedToday.removeAll()
            return
        }
        
        if today != lastResetDay {
            lastResetDay = today
            checkedToday.removeAll()
        }
    }
    
    private func toggleCheck(for worship: String) {
        resetIfNewDay()
        checkStreakValidity()
        
        let wasAllChecked = checkedToday.count == selectedWorships.count
        
        if checkedToday.contains(worship) {

            checkedToday.remove(worship)
            
            let nowAllUnchecked = checkedToday.isEmpty
            
            if nowAllUnchecked {
                streakCount = 0
                lastCheckTime = 0
            }
            
        } else {
            checkedToday.insert(worship)
            
            let nowAllChecked = checkedToday.count == selectedWorships.count
            
            if nowAllChecked && !wasAllChecked {

                lastCheckTime = Date().timeIntervalSince1970
                
                if streakCount < 30 {
                    streakCount += 1
                    
                    fireAnimation = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        fireAnimation = false
                    }
                }
            }
        }
    }
}


struct WorshipProgressCard: View {
    let worshipName: String
    let isChecked: Bool
    let onToggle: () -> Void
    
    @AppStorage("streakCount") private var streakCount: Int = 0
    
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
                ZStack {
                    ProgressRing(total: 30, count: streakCount, size: 80)
                    
                    Text("\(streakCount)/30")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(textColor)
                }
                .padding(.leading, 15)
                
                Spacer()
                
                Button {
                    onToggle()
                } label: {
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
                .padding(.trailing, 15)
                .padding(.top, 30)
            }
            
            Spacer()
        }
        .frame(width: 165, height: 165)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.4))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.5), lineWidth: 1.5)
        )
    }
    
}

#Preview {
    Tracker()
}
