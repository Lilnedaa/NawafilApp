import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel

    init(topic: NawafilTopic) {
        _viewModel = StateObject(
            wrappedValue: ContentViewModel(topic: topic)
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                VStack(spacing: 15) {
                    Text(viewModel.pageTitle)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.darkgreen)
                        .padding(.top, 75)
                        .padding(.bottom, 15)
                    
                    TabView(selection: $viewModel.currentIndex) {
                        ForEach(Array(viewModel.cards.enumerated()), id: \.element.id) { index, card in
                            GeometryReader { geo in
                                let minX = geo.frame(in: .global).minX
                                let screenWidth = UIScreen.main.bounds.width
                                let offset = minX - (screenWidth / 2 - 280 / 2)
                                let absOffset = abs(offset)

                                let scale = 1 - min(absOffset / screenWidth, 0.12)
                                let verticalOffset = min(absOffset / 8, 40)

                                CardView(
                                    title: card.title,
                                    content: card.content
                                )
                                .scaleEffect(scale)
                                .offset(y: verticalOffset)
                                .frame(width: geo.size.width, height: geo.size.height)
                            }
                            .frame(width: 280, height: 500)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 550)

                    // Page Indicator مع 4 نقاط فقط
                    PageIndicator(
                        currentPage: viewModel.currentIndex,
                        totalPages: viewModel.cards.count,
                        maxDots: 4
                    )
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.locale, Locale(identifier: "ar"))
    }
}

struct PageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    let maxDots: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(visibleDotIndices, id: \.self) { index in
                Circle()
                    .fill(currentPage == index ? Color.darkgreen : Color.gray.opacity(0.4))
                    .frame(width: 8, height: 8)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentPage)
    }
    
    private var visibleDotIndices: [Int] {
        guard totalPages > maxDots else {
            return Array(0..<totalPages)
        }
        
        let startIndex: Int
        let endIndex: Int
        
        if currentPage < maxDots - 1 {
            startIndex = 0
            endIndex = maxDots - 1
        } else if currentPage >= totalPages - (maxDots - 1) {
            startIndex = totalPages - maxDots
            endIndex = totalPages - 1
        } else {
            startIndex = currentPage - (maxDots - 2)
            endIndex = currentPage + 1
        }
        
        return Array(startIndex...endIndex)
    }
}

struct CardView: View {
    let title: String
    let content: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.zaeity)
                .frame(width: 280, height: 500)
            
            VStack(spacing: 15) {
                Text(title)
                    .foregroundColor(.baje)
                    .font(.system(size: 34, weight: .bold))
                    .padding(.top,50)
                
                Text(content)
                    .foregroundColor(.baje)
                    .font(.system(size: 17, weight: .medium))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, 25)
                    .frame(maxHeight: 300)

                Spacer(minLength: 20)
            }
            .frame(width: 280, height: 500)
        }
    }
}

#Preview {
    ContentView(topic: .duha)
}
