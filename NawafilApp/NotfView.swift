
import SwiftUI

struct NotfView: View {
    @State private var salahN = false
    @State private var qiyamN = true
    @State private var adkarN = false
    @State private var AshuraN = true
    @State private var ArafaN = false
    @State private var WhiteDaysN = false
    @State private var MondayN = false
    @State private var ShawwalN = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 20)
                    
                    NotificationCard(
                        title: "النوافل",
                        items: [
                            NotificationItem(title: "الصدقة", isOn: $salahN),
                            NotificationItem(title: "قيام الليل", isOn: $qiyamN),
                            NotificationItem(title: "اذكار الصباح والمساء", isOn: $adkarN)
                        ]
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    NotificationCard(
                        title: "الصيام",
                        items: [
                            NotificationItem(title: "عاشوراء", isOn: $AshuraN),
                            NotificationItem(title: "يوم عرفة", isOn: $ArafaN),
                            NotificationItem(title: "أيام البيض", isOn: $WhiteDaysN),
                            NotificationItem(title: "ست من شوال", isOn: $MondayN),
                            NotificationItem(title: "الاثنين والخميس", isOn: $ShawwalN)
                        ]
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("تفعيل الاشعارات")
                        .font(.system(size: 30, weight: .bold, design: .default))
                        .foregroundColor(textColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: HomeView()) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.black)
                    }
                }
            }
            .toolbarBackground(backgroundColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}
struct NotificationCard: View {
    let title: String
    let items: [NotificationItem]
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.system(size: 22, weight: .bold, design: .default))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 20)
                .padding(.vertical, 16)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
            
            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    NotificationRow(item: item)
                    
                    if index < items.count - 1 {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 1)
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
        .background(.zaeity)
        .cornerRadius(30)
    }
}

struct NotificationItem {
    let title: String
    var isOn: Binding<Bool>
}

struct NotificationRow: View {
    let item: NotificationItem
    
    var body: some View {
        HStack {
            Toggle("", isOn: item.isOn)
                .labelsHidden()
                .tint(.green)
            
            Spacer()
            
            Text(item.title)
                .font(.system(size: 18, weight: .regular, design: .default))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

#Preview {NotfView()}
