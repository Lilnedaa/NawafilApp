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
                        .font(.custom("SF Arabic Pro", size: 48))
//                        .fontWeight(.bold)
                        .foregroundColor(textColor)
                        .padding(.top, 10)
                    
                    Text(description)
                    
//                        .font(.custom("SF Arabic Pro", size: 16))
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
            .navigationBarHidden(true)
        }
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.locale, Locale(identifier: "ar"))
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
        NavigationLink(
            destination: ContentView(
                title: title,
                cards: sampleCards(for: title)
            )
        ) {
            Text(title)
                .font(.system(size: 25, weight: .bold, design: .default))
                .foregroundColor(.baje)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                .frame(height: 56)
                .background(.zaeity)
                .cornerRadius(27)
//                .glassEffect()
        }
        .environment(\.layoutDirection, .rightToLeft)
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

