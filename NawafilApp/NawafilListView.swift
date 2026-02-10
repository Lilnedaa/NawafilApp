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
    let items: [NawafilItem]

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing:0) {
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
                        ForEach(items) { item in
                            CButton(item: item)
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

// Model
struct NawafilItem: Identifiable {
    let id = UUID()
    let title: String
    let topic: NawafilTopic
    
    init(title: String, topic: NawafilTopic) {
        self.title = title
        self.topic = topic
    }
}


struct SalahView: View {
    var body: some View {
        NawafilListView(
            title: "الصلاة",
            description: "الصيام عبادة يقوم فيها المسلم بالإمساك عن الطعام والشراب وكل ما يُفطر من طلوع الفجر حتى غروب الشمس",
            items: [
                NawafilItem(title: "قيام الليل", topic: .qiyam),
                NawafilItem(title: "صلاة الضحى", topic: .dhuha),
                NawafilItem(title: "سنة الفجر", topic: .sunnahFajr),
                NawafilItem(title: "سنة الظهر", topic: .sunnahDhuhr),
                NawafilItem(title: "سنة المغرب", topic: .sunnahMaghrib),
                NawafilItem(title: "سنة العشاء", topic: .sunnahIsha)
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
                NawafilItem(title: "صيام الاثنين والخميس", topic: .mondayThursday),
                NawafilItem(title: "صيام الأيام البيض", topic: .whiteDays),
                NawafilItem(title: "صيام يوم عرفة", topic: .arafah),
                NawafilItem(title: "صيام يوم عاشوراء", topic: .ashura),
                NawafilItem(title: "صيام ستة من شوال", topic: .shawwal)
            ]
        )
    }
}


struct CButton: View {
    let item: NawafilItem  
    
    var body: some View {
        NavigationLink(destination: ContentView(topic: item.topic)) {
            Text(item.title)
                .font(.system(size: 25, weight: .bold, design: .default))
                .foregroundColor(.baje)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                .frame(height: 56)
                .background(.zaeity)
                .cornerRadius(27)
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}

#Preview {
    NawafilListView(
        title: "الصلاة",
        description: " الصلاة عبادة يقوم فيها المسلم بالسجود والركوع ",
        items: [
            NawafilItem(title: "قيام الليل", topic: .qiyam),
            NawafilItem(title: "سنة الفجر", topic: .sunnahFajr),
            NawafilItem(title: "سنة الظهر", topic: .sunnahDhuhr),
            NawafilItem(title: "سنة المغرب", topic: .sunnahMaghrib),
            NawafilItem(title: "سنة العشاء", topic: .sunnahIsha),
            NawafilItem(title: "صلاة الضحى", topic: .dhuha)
        ]
    )
}
