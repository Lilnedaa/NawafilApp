//
//  HomeView.swift
//  NawafilApp
//
//  Created by Rana on 20/08/1447 AH.
//

import SwiftUI

struct HomeView: View {

    @State private var selectedIndex: Int = 0

    var body: some View {
        ZStack(alignment: .bottom) {

            backgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {

                    header

                    nowButtonsSection

                    Divider()
                        .overlay(textColor.opacity(0.12))
                        .padding(.top, 2)

                    sectionTitle

                    cardsSection

                    Spacer(minLength: 110)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }

        }
        .environment(\.layoutDirection, .leftToRight)
    }
}

// MARK: - Header
private extension HomeView {
    var header: some View {
        HStack(alignment: .top) {

            Image(systemName: "bell.fill")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(textColor)
                .frame(width: 40, height: 40)
                .background(Color.white.opacity(0.55), in: Circle())

            Spacer()

            VStack(spacing: 6) {
                Text("١٠ محرم ١٤٤٧")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(textColor)

                Text("ص ٠:٣٠")
                    .font(.custom("SF Arabic", size: 16).weight(.regular))
                    .foregroundStyle(textColor.opacity(0.7))
            }

            Spacer()

            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.top, 20)
    }
}

// MARK: - Now Buttons (1 pill per page) + Swipe + Dots
private extension HomeView {

    private var nowItems: [(String, String, String)] {
        [
            ("يحدث الآن", "أذكار الصباح", "sun.max.fill"),
            ("يحدث الآن", "أذكار المساء", "moon.stars.fill"),
            ("يحدث الآن", "قيام", "moon.fill")
        ]
    }

    var nowButtonsSection: some View {
        VStack(spacing: 12) {

            TabView(selection: $selectedIndex) {
                ForEach(0..<nowItems.count, id: \.self) { i in
                    nowButtonsPage(item: nowItems[i])
                        .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 68)

            HStack(spacing: 6) {
                nowDot(0)
                nowDot(1)
                nowDot(2)
            }
        }
        .padding(.top, 8)
    }

    // ✅ صفحة واحدة = زر واحد فقط (هذا اللي يخلي في زر يمين ويسار يظهر جزء منه)
    func nowButtonsPage(item: (String, String, String)) -> some View {
        HStack {
            Button(action: {
                print("Tapped: \(item.1)")
            }) {
                NowPill(
                    top: item.0,
                    title: item.1,
                    icon: item.2
                )
                .frame(width: 227, height: 68)
            }
            .buttonStyle(.plain)
        }
        // ✅ هذا يخلي الزر في المنتصف ويظهر جزء من اللي قبله وبعده
        .padding(.horizontal, 30)
    }

    func nowDot(_ index: Int) -> some View {
        Circle()
            .fill(selectedIndex == index ? textColor.opacity(0.65) : textColor.opacity(0.35))
            .frame(width: 7, height: 7)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut) { selectedIndex = index }
            }
    }
}

// MARK: - Section Title
private extension HomeView {
    var sectionTitle: some View {
        Text("العبادات")
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 6)
    }
}

// MARK: - Cards (Buttons) - 4 sections
private extension HomeView {
    var cardsSection: some View {
        VStack(spacing: 14) {

            Button(action: { print("الصدقة") }) {
                WorshipCard(imageName: "image", title: "الصدقة", subtitle: "القليل دائم خير")
            }
            .buttonStyle(.plain)

            Button(action: { print("الصلاة") }) {
                WorshipCard(imageName: "image1", title: "الصلاة", subtitle: "سنن تقربك إلى الله")
            }
            .buttonStyle(.plain)

            Button(action: { print("الأذكار") }) {
                WorshipCard(imageName: "image2", title: "الأذكار", subtitle: "طمأنينة القلب")
            }
            .buttonStyle(.plain)

            Button(action: { print("الصيام") }) {
                WorshipCard(imageName: "image2", title: "الصيام", subtitle: "باب للخير ورفع الدرجات")
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 6)
    }
}

// MARK: - Bottom Nav
//private extension HomeView {
   //var bottomNav: some View {
  //      AppTabBar(selectedIndex: 1) // ( حعدلها على حسب التاب بار حق وصال)
  //  }
//}


// MARK: - Components

private struct NowPill: View {
    let top: String
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 12) {

            VStack(alignment: .trailing, spacing: 4) {
                Text(top)
                    .font(.system(size: 12, weight: .bold))
                    .font(.custom("SF Arabic", size: 12))
                    .foregroundStyle(.white.opacity(0.55))
                    .lineLimit(1)

                Text(title)
                    .font(.custom("SF Arabic", size: 16).weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            Image(systemName: icon)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 18)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(buttonColor)
                // inset white shadow مثل فيقما
                .shadow(color: Color.white, radius: 2, x: 0, y: 1)
        )
        .contentShape(Rectangle())
    }
}


private struct WorshipCard: View {
    let imageName: String
    let title: String
    let subtitle: String

    var body: some View {
        ZStack(alignment: .topTrailing) {

            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .black.opacity(0.05),
                                    .black.opacity(0.25),
                                    .black.opacity(0.55)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                .clipped()

            VStack(alignment: .trailing, spacing: 6) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color(hex: "EEEEEE"))

                Text(subtitle)
                    .font(.custom("SF Arabic", size: 16).weight(.regular))
                    .foregroundStyle(Color(hex: "EEEEEE").opacity(0.9))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .multilineTextAlignment(.trailing)
            .allowsHitTesting(false)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}


private extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    HomeView()
        .environment(\.layoutDirection, .leftToRight)
}
