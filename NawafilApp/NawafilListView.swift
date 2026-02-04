//
//  NawafilListView.swift
//  NawafilApp
//
//  Created by Nedaa on 04/02/2026.
//

import SwiftUI


struct NawafilListView: View {
    let title: String
    let description: String
    let items: [String]
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Text(title)
                        .font(.system(size: 48, weight: .bold, design: .default))
//                        .font(.custom("SF Arabic Pro", size: 48))
//                        .fontWeight(.bold)
                        .foregroundColor(textColor)
                        .padding(.top, 10)
                    
                    Text(description)
                        .font(.custom("SF Arabic Pro", size: 16))
                        .fontWeight(.thin)
                        .foregroundColor(textColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 50)
                    
                    Spacer()
                        .frame(height: 50)
                    
                    VStack(spacing: 16) {
                        ForEach(items, id: \.self) { item in
                            CButton(title: item)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    .frame(height: 80)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 0)
                }
            }
           // .navigationBarHidden(true)
        }
    }
}


struct SalahView: View {
    var body: some View {
        NawafilListView(
            title: "الصلاة",
            description: "الصيام عبادة يقوم فيها المسلم بالإمساك عن الطعام والشراب وكل ما يُفطر من طلوع الفجر حتى غروب الشمس",
            items: [
                "قيام الليل",
                "صلاة الضحى",
                "سنة الفجر",
                "سنة الظهر",
                "سنة المغرب",
                "سنة العشاء"
            ]
        )
    }
}

struct SiamView: View {
    var body: some View {
        NawafilListView(
            title: "الصيام",
            description: "الصيام عبادة يقوم فيها المسلم بالإمساك عن الطعام والشراب وكل ما يُفطر من طلوع الفجر حتى غروب الشمس",
            items: [
                "صيام الاثنين والخميس",
                "صيام الأيام البيض",
                "صيام يوم عرفة",
                "صيام يوم عاشوراء",
                "صيام ستة من شوال"
            ]
        )
    }
}


struct CButton: View {
    let title: String
    
    var body: some View {
        NavigationLink(destination: ContentView()) {
            Text(title)
                .font(.system(size: 25, weight: .bold, design: .default))
//                .font(.custom("SF Arabic Pro", size: 25))
//                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 40)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            backgroundColor.opacity(0.3),
                            backgroundColor.opacity(0.15)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .background(buttonColor)
                .cornerRadius(27)
                .glassEffect()
                //.cornerRadius(12)
        }
    }
}

#Preview {
    NawafilListView(
        title: "الصلاة",
        description: " الصلاة عبادة يقوم فيها المسلم بالسجود والركوع ",
        items: [
            " قيام الليل",
            " سنة الفجر",
            " سنة الظهر",
            "سنة المغرب",
            "سنة العشاء",
            "صلاة الضحى"
        ]
    )
}

