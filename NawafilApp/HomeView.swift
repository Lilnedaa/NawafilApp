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
        NavigationStack {
            ZStack(alignment: .bottom) {
                backgroundColor.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        // Header
                        VStack(spacing: 6) {
                            Text("١٠ محرم ١٤٤٧")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(textColor)
                            
                            Text("ص ٩:٣٠")
                                .font(.custom("SF Arabic", size: 16).weight(.regular))
                                .foregroundStyle(textColor.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        
                        // Buttons with Swipe
                        VStack(spacing: 12) {
                            TabView(selection: $selectedIndex) {
                                nowPillButton("يحدث الآن", "أذكار الصباح", "sun.max.fill").tag(0)
                                nowPillButton("يحدث الآن", "أذكار المساء", "moon.stars.fill").tag(1)
                                nowPillButton("يحدث الآن", "قيام الليل", "moon.fill").tag(2)
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            .frame(height: 68)
                            
                            // Dots
                            HStack(spacing: 6) {
                                ForEach(0..<3) { i in
                                    Circle()
                                        .fill(selectedIndex == i ? textColor.opacity(0.65) : textColor.opacity(0.35))
                                        .frame(width: 7, height: 7)
                                        .onTapGesture {
                                            withAnimation(.easeInOut) { selectedIndex = i }
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
                        
                        // Cards
                        VStack(spacing: 14) {
                            cardButton("image1", "الصلاة", "القليل دائم خير")
                            cardButton("image2", "الصيام", "سنن تقربك إلى الله")
                            cardButton("image", "الصدقة", "طمأنينة القلب")
                            cardButton("image3", "الاذكار", "باب للخير ورفع الدرجات")
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
                    Button {
                        print("Notifications tapped")
                    } label: {
                        Image(systemName: "bell.fill")
                            .foregroundColor(textColor)
    
                    }
                }
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
                        .foregroundStyle(.white.opacity(0.55))
                    
                    Text(title)
                        .font(.custom("SF Arabic", size: 20).weight(.bold))
                        .foregroundStyle(.white)
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
                    .shadow(color: .white, radius: 2, x: 0, y: 1)
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 30)
    }
    
    // MARK: - Card Button
    func cardButton(_ image: String, _ title: String, _ subtitle: String) -> some View {
        Button {
            print(title)
        } label: {
            ZStack(alignment: .topTrailing) {
                // Image with gradient
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
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
                
                // Text sections
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
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
        .environment(\.layoutDirection, .leftToRight)
}
