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

    @State private var showAlert = false
    @State private var selectedItem: NawafilItem?

    
    init(
        title: String = "النوافل",
        description: String = "",
        items: [NawafilItem] = []
    ) {
        self.title = title
        self.description = description
        self.items = items
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Text(title)
                        .font(.system(size: 48, weight: .bold, design: .default))
                        .font(.custom("SF Arabic Pro", size: 48))
                        .foregroundColor(textColor)
                        .padding(.top, 10)

                    Text(description)
                        .fontWeight(.regular)
                        .foregroundColor(textColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 50)

                    Spacer()
                        .frame(height: 50)

                    VStack(spacing: 16) {
                        ForEach(items) { item in
                            CButton(item: item, onTap: {
                                if item.url != nil {
                                    selectedItem = item
                                    showAlert = true
                                }
                            })
                        }
                    }
                    .padding(.horizontal, 40)

                    Spacer()

                        .frame(height: 75)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 0)
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .environment(\.locale, Locale(identifier: "ar"))

        .alert("التبرع عبر \(selectedItem?.title ?? "")", isPresented: $showAlert) {
            Button("إلغاء", role: .cancel) { }
            Button("نعم، أريد التصدق") {
                if let urlString = selectedItem?.url,
                   let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text("سيتم نقلك إلى الموقع الرسمي لإتمام التبرع")
        }
    }
}

// Model
struct NawafilItem: Identifiable {
    let id = UUID()
    let title: String
    let topic: NawafilTopic
    let url: String?

    init(title: String, topic: NawafilTopic, url: String? = nil) {
        self.title = title
        self.topic = topic
        self.url = url
    }
}

struct SalahView: View {
    var body: some View {
        NawafilListView(
            title: "الصلاة",
            description: "الصلاة عبادة يتقرب بها المسلم إلى الله بأقوال وأفعال مخصوصة في أوقات محددة",
            items: [
                NawafilItem(title: "سنة الفجر", topic: .sunnahFajr),
                NawafilItem(title: "صلاة الضحى", topic: .duha),
                NawafilItem(title: "سنة الظهر", topic: .sunnahDhuhr),
                NawafilItem(title: "سنة المغرب", topic: .sunnahMaghrib),
                NawafilItem(title: "سنة العشاء", topic: .sunnahIsha),
                NawafilItem(title: "قيام الليل", topic: .qiyam)
            ]
        )
    }
}

struct SiamView: View {
    var body: some View {
        NawafilListView(
            title: "الصيام",
            description: "الصيام عبادة يمسك فيها المسلم عن المفطرات من طلوع الفجر إلى غروب الشمس تقرباً إلى الله",
            items: [
                NawafilItem(title: "صيام الاثنين و الخميس", topic: .mondayThursday),
                NawafilItem(title: "صيام الأيام البيض", topic: .whiteDays),
                NawafilItem(title: "صيام يوم عرفة", topic: .arafah),
                NawafilItem(title: "صيام يوم عاشوراء", topic: .ashura),
                NawafilItem(title: "صيام العشر من ذي الحجة", topic: .dhuHijahTen),
                NawafilItem(title: "صيام ستة من شوال", topic: .shawwal)
            ]
        )
    }
}

struct SadaqahView: View {
    var body: some View {
        NawafilListView(
            title: "الصدقة",
            description: "الصدقة عبادة يتقرب بها المسلم إلى الله ببذل المال أو المنفعة أو المعروف للمحتاجين ابتغاء مرضاة الله، وهي سبب للبركة وتكفير الذنوب",
            items: [
                NawafilItem(title: "منصة إحسان", topic: .ehsan, url: "https://ehsan.sa"),
                NawafilItem(title: "منصة شفاء", topic: .shifa, url: "https://shifa.moh.gov.sa")
            ]
        )
    }
}


struct AdhkarView: View {
    var body: some View {
        NawafilListView(
            title: "الأذكار",
            description: "الأذكار عبادة يقوم فيها المسلم بذكر الله بالتسبيح والتحميد والتهليل والدعاء في أوقات مختلفة، طلباً للأجر وطمأنينة القلب والقرب من الله",
            items: [
                NawafilItem(title:"أذكار الصباح", topic: .morningAdhkar),
                NawafilItem(title:"أذكار المساء", topic: .eveningAdhkar)
            ]
        )
    }
}


struct CButton: View {
    let item: NawafilItem
    let onTap: (() -> Void)?
    
    init(item: NawafilItem, onTap: (() -> Void)? = nil) {
        self.item = item
        self.onTap = onTap
    }

    var body: some View {
        if item.url != nil {
            Button(action: {
                onTap?()
            }) {
                buttonContent
            }
        } else {
            NavigationLink(destination: ContentView(topic: item.topic)) {
                buttonContent
            }
        }
    }
    
    private var buttonContent: some View {
        Text(item.title)
            .font(.system(size: 22, weight: .regular, design: .default))
            .foregroundColor(.baje)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)
            .frame(height: 56)
            .background(.zaeity)
            .cornerRadius(20)
            .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    NawafilListView(
        title: "الصلاة",
        description: "الصلاة عبادة يتقرب بها المسلم إلى الله بأقوال وأفعال مخصوصة في أوقات محددة",
        items: [
            NawafilItem(title: "سنة الفجر", topic: .sunnahFajr),
            NawafilItem(title: "صلاة الضحى", topic: .duha),
            NawafilItem(title: "سنة الظهر", topic: .sunnahDhuhr),
            NawafilItem(title: "سنة المغرب", topic: .sunnahMaghrib),
            NawafilItem(title: "سنة العشاء", topic: .sunnahIsha),
            NawafilItem(title: "قيام الليل", topic: .qiyam)
        ]
    )
}
