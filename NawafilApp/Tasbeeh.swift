import SwiftUI
import WidgetKit

struct Tsbeeh: View {
    
    // ✅ الهدف (التوتال) مخزن في App Group
    @AppStorage("tasbeeh_total", store: UserDefaults(suiteName: "group.com.wessal.nawafil"))
    private var total: Int = 100
    
    // ✅ العداد مخزن في App Group
    @AppStorage("tasbeeh_count", store: UserDefaults(suiteName: "group.com.wessal.nawafil"))
    private var count: Int = 0
    
    @State private var showEditTotal = false
    
    var progress: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total)
    }
    
    var body: some View {
        
        ZStack{
            
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
                }.padding()
                
                HStack(spacing: 24) {
                    
                    Button {
                        // Reset
                        count = 0
                        WidgetCenter.shared.reloadAllTimelines()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title2)
                            .foregroundStyle(Color(buttonColor))
                            .frame(width: 56, height: 56)
                         //   .background(Color(buttonColor))
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
                          //  .background(Color(buttonColor))
                    }
                    .glassEffect()
                    .clipShape(Circle())
                    
                    Button {
                        // Increment
                        
                            count += 1
                        
                        WidgetCenter.shared.reloadAllTimelines()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(Color(buttonColor))
                            .frame(width: 56, height: 56)
                           // .background(Color(buttonColor))
                    }
                    .glassEffect()
                    .clipShape(Circle())
                }
                .padding(.top, 24)
            }
            .sheet(isPresented: $showEditTotal) {
                EditTotalSheet(total: $total, count: $count)
                    .presentationDetents([.medium])
            }
        }
    }
    
}

struct EditTotalSheet: View {
    @Binding var total: Int
    @Binding var count: Int

    @Environment(\.dismiss) private var dismiss
    @State private var input: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("تعديل الهدف")
                .font(.title2.bold())

            Text("حددي عدد الأذكار المستهدف (مثلاً 33 / 100 / 1000).")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextField("مثال: 100", text: $input)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            HStack(spacing: 12) {
                Button("إلغاء") {
                    dismiss()
                }
                .buttonStyle(.bordered)

                Button("حفظ") {
                    let newTotal = Int(input) ?? total
                    let safeTotal = max(1, newTotal)

                    total = safeTotal
                    // لو العداد أكبر من الهدف الجديد، نعدله
                    if count > total { count = total }

                    WidgetCenter.shared.reloadAllTimelines()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            input = "\(total)"
        }
    }
}

#Preview {
    Tsbeeh()
}
