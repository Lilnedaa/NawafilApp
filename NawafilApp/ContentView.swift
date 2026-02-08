//
//  Untitled.swift
//  NawafilApp
//
//  Created by Eatzaz Hafiz on 07/02/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentIndex = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea(edges: .all)
                
                VStack(spacing: 0) {
                    
                    Spacer()
                    
                    TabView(selection: $currentIndex) {
                        ForEach(0..<3) { index in
                            GeometryReader { geo in
                                let minX = geo.frame(in: .global).minX
                                let screenWidth = UIScreen.main.bounds.width
                                let offset = minX - (screenWidth / 2 - 270 / 2)
                                let absOffset = abs(offset)
                                
                                let scale = 1 - min(absOffset / screenWidth, 0.12)
                                let verticalOffset = min(absOffset / 8, 40)
                                
                                CardView(
                                    title: getCardTitle(for: index),
                                    content: getCardContent(for: index)
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
                    
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(currentIndex == index ? Color.titlecolor : Color.gray.opacity(0.4))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("صلاة الضحى")
//                        .font(.custom("SF Arabic Pro", size: 36))
                        .font(.system(size: 34, weight: .bold, design: .default))
                        .fontWeight(.bold)
                        .foregroundColor(.titlecolor)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
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
                .fill(.cards)
                .frame(width: 270, height: 480)
                .cornerRadius(24)
            
            VStack(spacing: 20) {
                Text(title)
   //                 .foregroundColor(.textcolor)
//                    .font(.custom("SF Arabic", size: 36))
                    .font(.system(size: 36, weight: .bold, design: .default))
//                    .foregroundColor(.textcolor)
                    .font(.custom("SF Arabic", size: 30))

                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                Spacer()
                
                Text(content)
          //          .foregroundColor(.textcolor)
//                    .font(.custom("SF Arabic", size: 18))
                    .font(.system(size: 18, weight: .regular, design: .default))

                  //  .foregroundColor(.textcolor)
                    .font(.custom("SF Arabic", size: 14))
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .padding(.horizontal, 20)
                
                Spacer()
            }
            .frame(width: 270, height: 480)
        }
    }
}

#Preview {
    ContentView()
}
