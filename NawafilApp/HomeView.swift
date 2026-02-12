//
//  HomeView.swift
//  NawafilApp
//
//  Created by Rana on 20/08/1447 AH.

import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                backgroundColor.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        // Header
                        VStack(spacing: 6) {
                            Text(vm.hijriDateText)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(textColor)

                            Text(vm.timeText)
                                .font(.custom("SF Arabic", size: 16).weight(.regular))
                                .foregroundStyle(textColor.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

                        // Buttons with Swipe
                        VStack(spacing: 12) {
                            TabView(selection: $vm.selectedIndex) {

                                // ✅ إذا ما فيه أحداث
                                if vm.events.isEmpty {
                                    emptyEventPill("لا يوجد حدث حاليًا")
                                        .tag(0)
                                } else {
                                    ForEach(Array(vm.events.enumerated()), id: \.element.id) { index, item in
                                        nowPillButton(item.top, item.title, item.icon)
                                            .tag(index)
                                    }
                                }

                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            .frame(height: 68)

                            // Dots (Dynamic)
                            HStack(spacing: 6) {
                                ForEach(0..<max(vm.events.count, 1), id: \.self) { i in
                                    Circle()
                                        .fill(vm.selectedIndex == i ? textColor.opacity(0.65) : textColor.opacity(0.35))
                                        .frame(width: 7, height: 7)
                                        .onTapGesture {
                                            withAnimation(.easeInOut) { vm.selectedIndex = i }
                                        }
                                }
                            }
                        }
                        .padding(.top, 8)

                        Divider()
                            .overlay(textColor.opacity(0.12))

                        // Section Title
                        Text("العبادات")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(textColor)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.top, 6)

                        // Cards (كلها تفتح نفس صفحة النوافل)
                        VStack(spacing: 14) {

                            NavigationLink(destination: SalahView()) {
                                cardContent("image1", "الصلاة", "القليل دائم خير")
                            }
                            .buttonStyle(.plain)

                            NavigationLink(destination: SiamView()) {
                                cardContent("image2", "الصيام", "سنن تقربك إلى الله")
                            }
                            .buttonStyle(.plain)

                            NavigationLink(destination: SalahView()) {
                                cardContent("image", "الصدقة", "طمأنينة القلب")
                            }
                            .buttonStyle(.plain)

                            NavigationLink(destination: AdhkarView()) {
                                cardContent("image3", "الاذكار", "باب للخير ورفع الدرجات")
                            }
                            .buttonStyle(.plain)
                        }

                        .padding(.top, 6)

                        Spacer(minLength: 110)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NotfNotificationsView()) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(textColor)
                    }
                }
            }

            .onAppear {
                vm.onAppear()
            }
        }
    }

    // MARK: - Now Pill Button
    func nowPillButton(_ top: String, _ title: String, _ icon: String) -> some View {
        Button {
            print("Tapped: \(title)")
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(Color.white)

                VStack(alignment: .trailing, spacing: 4) {
                    Text(top)
                        .font(.custom("SF Arabic", size: 14).weight(.regular))
                        .foregroundStyle(.baje.opacity(0.55))

                    Text(title)
                        .font(.custom("SF Arabic", size: 20).weight(.bold))
                        .foregroundStyle(.baje)
                        .minimumScaleFactor(0.85)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .environment(\.layoutDirection, .leftToRight)
            .padding(.horizontal, 18)
            .frame(width: 227, height: 68)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(buttonColor)
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 30)
    }

    func emptyEventPill(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(.white)
            .frame(width: 227, height: 68)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(buttonColor)
                    .shadow(color: .white, radius: 2, x: 0, y: 1)
            )
            .padding(.horizontal, 30)
    }

    // ✅ نفس تصميم cardButton لكن بدون Button (عشان نستخدمه داخل NavigationLink)
    func cardContent(_ image: String, _ title: String, _ subtitle: String) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.0),
                                    Color.white.opacity(0.40),
                                    Color.white.opacity(0.60)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 70) // تحكمي بارتفاع الشيد هنا
                }


            VStack(alignment: .trailing, spacing: 6) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color(backgroundColor))

                Text(subtitle)
                    .font(.custom("SF Arabic", size: 16))
                    .foregroundStyle(Color(backgroundColor).opacity(0.9))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview {
    HomeView()
        .environment(\.layoutDirection, .leftToRight)
}
