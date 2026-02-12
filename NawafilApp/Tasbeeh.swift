import SwiftUI
import WidgetKit

struct EditTotalSheet: View {
    @Binding var total: Int
    @Binding var count: Int
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTotal: Int = 100
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.callout)
                            .foregroundStyle(Color(buttonColor))
                            .frame(width: 36, height: 36)
                    }
                    .glassEffect()
                    .clipShape(Circle())
                    
                    Spacer()
                    
                    Text("تحديد الهدف")
                        .font(.subheadline.bold())
                        .foregroundStyle(Color(textColor))
                    
                    Spacer()
                    
                    Button {
                        total = selectedTotal
                        if count > total {
                            count = total
                        }
                        WidgetCenter.shared.reloadAllTimelines()
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.callout)
                            .foregroundStyle(.white)
                            .frame(width: 36, height: 36)
                            .background(
                                LinearGradient(
                                    colors: [Color(buttonColor).opacity(0.8), Color(buttonColor)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                    }
                    .glassEffect()
                    .clipShape(Circle())
                }
                .padding(.horizontal)
                
                HStack(spacing: 20) {
                    
                    Button {
                        if selectedTotal > 10 {
                            selectedTotal -= 10
                        }
                    } label: {
                        Image(systemName: "minus")
                            .font(.title3)
                            .foregroundStyle(Color(buttonColor))
                            .frame(width: 44, height: 44)
                    }
                    .glassEffect()
                    .clipShape(Circle())
                    
                    ZStack {
                        Circle()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [Color(buttonColor).opacity(0.3), Color(buttonColor)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 6
                            )
                            .frame(width: 90, height: 90)
                        
                        Text("\(selectedTotal)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(Color(textColor))
                    }
                    .glassEffect()
                    .clipShape(Circle())
                    .frame(width: 110, height: 110)
                    
                    Button {
                        selectedTotal += 10
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .foregroundStyle(Color(buttonColor))
                            .frame(width: 44, height: 44)
                    }
                    .glassEffect()
                    .clipShape(Circle())
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            selectedTotal = total
        }
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
                
                HStack(spacing: 24) {
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
                    
                    Button {
                        count += 1
                        WidgetCenter.shared.reloadAllTimelines()
                    } label: {
                        Image(systemName: "plus")
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
