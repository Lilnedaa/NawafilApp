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
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.darkgreen)
                        .padding(.top, 10)
                        .padding(.bottom, 5)

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

                    HStack {
                        ForEach(viewModel.cards.indices, id: \.self) { index in
                            Circle()
                                .fill(viewModel.currentIndex == index ? .darkgreen : .gray.opacity(0.4))
                                .frame(width: 8, height: 8)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.darkgreen)
                    }
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.locale, Locale(identifier: "ar"))
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
                    .padding(.top, 30)

                
                Spacer()
                
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
