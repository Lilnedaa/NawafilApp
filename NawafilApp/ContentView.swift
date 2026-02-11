//
//  Untitled.swift
//  NawafilApp
//
//  Created by Eatzaz Hafiz on 07/02/2026.
//

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
                VStack(spacing: 20) {

                    Text(viewModel.pageTitle)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.darkgreen)
                        .padding(.top, 20)

                    TabView(selection: $viewModel.currentIndex) {
                        ForEach(Array(viewModel.cards.enumerated()),
                                id: \.element.id) { index, card in
                            GeometryReader { geo in
                                let minX = geo.frame(in: .global).minX
                                let screenWidth = UIScreen.main.bounds.width
                                let offset = minX - (screenWidth / 2 - 270 / 2)
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
                            .frame(width: 270, height: 480)
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
                .frame(width: 270, height: 480)
            
            VStack(spacing: 20) {
                
                Text(title)
                    .foregroundColor(.baje)
//                    .font(.custom("SF Arabic", size: 36))
                    .font(.system(size: 36, weight: .bold))
//                    .foregroundColor(.textcolor)
                    .padding(.top, 40)
                
                Spacer()
                
                    Text(content)
                        .foregroundColor(.baje)
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                        .padding(.horizontal, 20)
                .frame(maxHeight: 260)

                Spacer(minLength: 20)
            }
            .frame(width: 270, height: 480)
        }
    }
}




#Preview {
    ContentView(topic: .dhuha)
}
