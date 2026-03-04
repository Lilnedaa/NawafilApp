import SwiftUI
import WidgetKit

struct EditTotalSheet: View {
    
    @Binding var total: Int
    @Binding var count: Int
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var selectedTotal: Int = 100
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                
                HStack {
                    
                    Button {
                        applyChanges()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color(buttonColor))
                            .clipShape(Circle())
                            .glassEffect(.regular.interactive(), in: Circle())
                    }
                    
                    Spacer()
                    
                    Text("تحديد الهدف")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(Color(textColor))
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(textColor))
                            .frame(width: 44, height: 44)
                            .glassEffect(.regular.tint(.clear).interactive(), in: Circle())
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                
                // MARK: - Controls
                HStack(spacing: 40) {
                    
                    // ناقص 10
                    Button {
                        if selectedTotal > 10 {
                            selectedTotal -= 10
                        }
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(buttonColor))
                            .frame(width: 44, height: 44)
                            .glassEffect(.regular.tint(.clear).interactive(), in: Circle())
                    }
                    
                    
                    // MARK: - Editable Circle
                    ZStack {
                        Circle()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color(buttonColor).opacity(0.3),
                                        Color(buttonColor)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 6
                            )
                            .frame(width: 90, height: 90)
                        
                        TextField("", value: $selectedTotal, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(Color(textColor))
                            .frame(width: 90, height: 90)
                            .focused($isTextFieldFocused)
                            .onChange(of: selectedTotal) { _, newValue in
                                if newValue < 1 { selectedTotal = 1 }
                                if newValue > 100000 { selectedTotal = 100000 }
                            }
                    }
                    .glassEffect()
                    .clipShape(Circle())
                    .frame(width: 110, height: 110)
                    
                    
                    // زائد 10
                    Button {
                        selectedTotal += 10
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(buttonColor))
                            .frame(width: 44, height: 44)
                            .glassEffect(.regular.tint(.clear).interactive(), in: Circle())
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            selectedTotal = total
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("تم") {
                    isTextFieldFocused = false
                }
            }
        }
    }
    
    
    // MARK: - Apply Logic
    private func applyChanges() {
        if selectedTotal < 1 {
            selectedTotal = 1
        }
        
        total = selectedTotal
        
        if count > total {
            count = total
        }
        
        WidgetCenter.shared.reloadAllTimelines()
        dismiss()
    }
}

struct Tsbeeh: View {
    
    @AppStorage("tasbeeh_total", store: UserDefaults(suiteName: "group.com.wessal.nawafil"))
    private var total: Int = 100
    
    @AppStorage("tasbeeh_count", store: UserDefaults(suiteName: "group.com.wessal.nawafil"))
    private var count: Int = 0
    
    @State private var showEditTotal = false
    
    var progress: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total)
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    ProgressRing(total: total, count: count, size: 300)

                    Circle()
                        .fill(Color.clear)
                        .frame(width: 300, height: 300)
                        .contentShape(Circle())
                        .onTapGesture {
                            count += 1
                            WidgetCenter.shared.reloadAllTimelines()
                        }

                    VStack(spacing: 8) {
                        Text("\(count)")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundStyle(Color(textColor))

                        Text("من \(total) ذكر")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                HStack(spacing: 150) {
                    Button {
                        count = 0
                        WidgetCenter.shared.reloadAllTimelines()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title2)
                            .foregroundStyle(Color(buttonColor))
                            .frame(width: 56, height: 56)
                    }
                    .glassEffect()
                    .clipShape(Circle())
                    
                    Button {
                        showEditTotal = true
                    } label: {
                        Image(systemName: "pencil")
                            .font(.title2)
                            .foregroundStyle(Color(buttonColor))
                            .frame(width: 56, height: 56)
                    }
                    .glassEffect()
                    .clipShape(Circle())
                    
                    
                }
                .padding(.top, 24)
            }
            .sheet(isPresented: $showEditTotal) {
                EditTotalSheet(total: $total, count: $count)
                    .presentationDetents([.height(220)])
            }
        }
    }
}

#Preview {
    Tsbeeh()
}
