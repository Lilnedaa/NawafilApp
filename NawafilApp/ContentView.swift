import SwiftUI

struct ContentView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentIndex = 1
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea(edges: .all)
                
                VStack(spacing: 0) {
                    Text("صلاة الضحى")
                        .foregroundColor(.titlecolor)
                        .font(.custom("SF Arabic Pro", size: 36))
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    GeometryReader { geometry in
                        let width = geometry.size.width
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: -150) {
                                ForEach(0..<3) { index in
                                    GeometryReader { cardGeometry in
                                        let minX = cardGeometry.frame(in: .global).minX
                                        let cardWidth: CGFloat = 219
                                        let screenCenter = width / 2
                                        let cardCenter = minX + cardWidth / 2
                                        let offset = abs(screenCenter - cardCenter)
                                        
                                        let scale = max(0.88, 1 - (offset / width) * 0.12)
                                        let verticalOffset = min(offset / 5, 40)
                                        
                                        CardView(
                                            title: getCardTitle(for: index),
                                            content: getCardContent(for: index)
                                        )
                                        .scaleEffect(scale)
                                        .offset(y: verticalOffset)
                                        .zIndex(offset > 50 ? 0 : 1)
                                    }
                                    .frame(width: 219, height: 390)
                                    .padding(.horizontal, (width - 219) / 2)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.paging)
                        .contentMargins(.horizontal, 0, for: .scrollContent)
                    }
                    .frame(height: 480)
                    
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                    } label: {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    func getCardTitle(for index: Int) -> String {
        switch index {
        case 0: return "حكمها"
        case 1: return "وقتها"
        case 2: return "عدد ركعاتها"
        default: return ""
        }
    }
    
    func getCardContent(for index: Int) -> String {
        switch index {
        case 0: return "صلاة الضحى سنة أوصى بها النبي ﷺ بعض أصحابه، وفعلها في بعض الأحيان -عليه الصلاة والسلام- وفعلها يوم الفتح، صلى ثمان ركعات الضحى يوم الفتح، فهي سنة مؤكدة."
        case 1: return "يبدأ وقت صلاة الضحى من ارتفاع الشمس قدر رمح، أي بعد شروق الشمس بنحو ربع ساعة، ويمتد إلى قبيل صلاة الظهر."
        case 2: return "أقلها ركعتان، وأوسطها أربع ركعات، وأفضلها ثمان ركعات، وأكثرها اثنتا عشرة ركعة."
        default: return ""
        }
    }
}

struct CardView: View {
    let title: String
    let content: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.cards,
                            Color.cards.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 219, height: 390)
                .cornerRadius(24)
            
            VStack(spacing: 20) {
                Text(title)
//                    .foregroundColor(.textcolor)
                    .font(.custom("SF Arabic", size: 30))
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                Spacer()
                
                Text(content)
//                    .foregroundColor(.textcolor)
                    .font(.custom("SF Arabic", size: 14))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, 16)
                
                Spacer()
            }
            .frame(width: 219, height: 390)
        }
    }
}

#Preview {
    ContentView()
}
