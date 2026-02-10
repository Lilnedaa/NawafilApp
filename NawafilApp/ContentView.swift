//
//  Untitled.swift
//  NawafilApp
//
//  Created by Eatzaz Hafiz on 07/02/2026.
//

import SwiftUI
import Foundation
import Combine


//// MODEL
//
//struct CardData: Identifiable {
//    let id = UUID()
//    let title: String
//    let content: String
//}
//
//enum NawafilTopic: String, CaseIterable, Identifiable {
//    // Prayer topics
//    case dhuha = "صلاة الضحى"
//    case qiyam = "قيام الليل"
//    case sunnahFajr = "سنة الفجر"
//    case sunnahDhuhr = "سنة الظهر"
//    case sunnahMaghrib = "سنة المغرب"
//    case sunnahIsha = "سنة العشاء"
//    
//    // Fasting topics
//    case mondayThursday = "صيام الاثنين والخميس"
//    case whiteDays = "صيام الأيام البيض"
//    case arafah = "صيام يوم عرفة"
//    case ashura = "صيام يوم عاشوراء"
//    case shawwal = "صيام ستة من شوال"
//
//    var id: String { rawValue }
//
//    var cards: [CardData] {
//        switch self {
//
//        // PRAYER TOPICS
//        case .dhuha:
//            return [
//                CardData(
//                    title: "حكمها",
//                    content: """
//صلاة الضحى سنة مؤكدة، أوصى بها النبي ﷺ بعض أصحابه،
//وفعلها في بعض الأحيان، وصلاها يوم فتح مكة ثمان ركعات.
//"""
//                ),
//                CardData(
//                    title: "وقتها",
//                    content: """
//يبدأ وقت صلاة الضحى من ارتفاع الشمس قدر رمح
//أي بعد الشروق بنحو ربع ساعة، ويمتد إلى قبيل الظهر.
//"""
//                ),
//                CardData(
//                    title: "عدد ركعاتها",
//                    content: """
//أقلها ركعتان، وأوسطها أربع ركعات،
//وأفضلها ثمان ركعات، وأكثرها اثنتا عشرة ركعة.
//"""
//                )
//            ]
//
//        case .qiyam:
//            return [
//                CardData(
//                    title: "فضلها",
//                    content: """
//قيام الليل من أفضل النوافل،
//وهو دأب الصالحين وقربة إلى الله تعالى.
//"""
//                ),
//                CardData(
//                    title: "وقته",
//                    content: """
//يبدأ من بعد صلاة العشاء،
//ويمتد إلى طلوع الفجر، وأفضله الثلث الأخير من الليل.
//"""
//                ),
//                CardData(
//                    title: "كيفيتها",
//                    content: """
//تصلى ركعتين ركعتين، ويُستحب أن يختمها بالوتر.
//والأفضل إحدى عشرة ركعة أو ثلاث عشرة ركعة.
//"""
//                )
//            ]
//            
//        case .sunnahFajr:
//            return [
//                CardData(
//                    title: "حكمها",
//                    content: """
//سنة الفجر ركعتان قبل صلاة الفجر،
//وهي من أكثر السنن تأكيداً ولم يكن النبي ﷺ يتركها.
//"""
//                ),
//                CardData(
//                    title: "فضلها",
//                    content: """
//قال النبي ﷺ: «ركعتا الفجر خير من الدنيا وما فيها».
//"""
//                ),
//                CardData(
//                    title: "وقتها",
//                    content: """
//تصلى بعد دخول وقت الفجر وقبل صلاة الفجر المفروضة.
//"""
//                )
//            ]
//            
//        case .sunnahDhuhr:
//            return [
//                CardData(
//                    title: "حكمها",
//                    content: """
//سنة الظهر أربع ركعات قبل الصلاة وركعتان بعدها.
//وهي من السنن الراتبة.
//"""
//                ),
//                CardData(
//                    title: "فضلها",
//                    content: """
//من حافظ على أربع ركعات قبل الظهر وأربع بعدها
//حرمه الله على النار.
//"""
//                ),
//                CardData(
//                    title: "كيفيتها",
//                    content: """
//تصلى أربع ركعات قبل الظهر بتسليمتين،
//وركعتان بعد الظهر.
//"""
//                )
//            ]
//            
//        case .sunnahMaghrib:
//            return [
//                CardData(
//                    title: "حكمها",
//                    content: """
//سنة المغرب ركعتان بعد صلاة المغرب.
//وهي من السنن الراتبة.
//"""
//                ),
//                CardData(
//                    title: "وقتها",
//                    content: """
//تصلى بعد صلاة المغرب مباشرة.
//"""
//                ),
//                CardData(
//                    title: "فضلها",
//                    content: """
//من صلى السنن الراتبة بنى الله له بيتاً في الجنة.
//"""
//                )
//            ]
//            
//        case .sunnahIsha:
//            return [
//                CardData(
//                    title: "حكمها",
//                    content: """
//سنة العشاء ركعتان بعد صلاة العشاء.
//وهي من السنن الراتبة.
//"""
//                ),
//                CardData(
//                    title: "فضلها",
//                    content: """
//هي من السنن الراتبة التي حث عليها النبي ﷺ
//ومن حافظ عليها بنى الله له بيتاً في الجنة.
//"""
//                ),
//                CardData(
//                    title: "وقتها",
//                    content: """
//تصلى بعد صلاة العشاء المفروضة مباشرة.
//"""
//                )
//            ]
//            
//        // FASTING TOPICS
//        case .mondayThursday:
//            return [
//                CardData(
//                    title: "حكمه",
//                    content: """
//صيام يومي الاثنين والخميس من كل أسبوع سنة مستحبة.
//كان النبي ﷺ يتحرى صيامهما.
//"""
//                ),
//                CardData(
//                    title: "فضله",
//                    content: """
//قال النبي ﷺ: «تُعرض الأعمال يوم الاثنين والخميس
//فأحب أن يُعرض عملي وأنا صائم».
//"""
//                ),
//                CardData(
//                    title: "سبب الفضل",
//                    content: """
//تُرفع الأعمال إلى الله في هذين اليومين،
//فيحب المسلم أن يُرفع عمله وهو صائم.
//"""
//                )
//            ]
//            
//        case .whiteDays:
//            return [
//                CardData(
//                    title: "حكمه",
//                    content: """
//صيام الأيام البيض هو صيام الأيام ١٣ و١٤ و١٥ من كل شهر قمري.
//وهو سنة مستحبة.
//"""
//                ),
//                CardData(
//                    title: "فضله",
//                    content: """
//قال النبي ﷺ: «صيام ثلاثة أيام من كل شهر
//صيام الدهر كله».
//"""
//                ),
//                CardData(
//                    title: "سبب التسمية",
//                    content: """
//سميت بالأيام البيض لأن القمر يكون بدراً فيها
//فتكون الليالي بيضاء مضيئة.
//"""
//                )
//            ]
//            
//        case .arafah:
//            return [
//                CardData(
//                    title: "حكمه",
//                    content: """
//صيام يوم عرفة سنة مؤكدة لغير الحاج.
//أما الحاج فالأفضل له الفطر.
//"""
//                ),
//                CardData(
//                    title: "فضله",
//                    content: """
//قال النبي ﷺ: «صيام يوم عرفة أحتسب على الله
//أن يكفر السنة التي قبله والسنة التي بعده».
//"""
//                ),
//                CardData(
//                    title: "وقته",
//                    content: """
//يوم عرفة هو اليوم التاسع من شهر ذي الحجة.
//وهو من أفضل أيام السنة.
//"""
//                )
//            ]
//            
//        case .ashura:
//            return [
//                CardData(
//                    title: "حكمه",
//                    content: """
//صيام يوم عاشوراء سنة مؤكدة.
//ويُستحب صيام يوم قبله أو بعده.
//"""
//                ),
//                CardData(
//                    title: "فضله",
//                    content: """
//قال النبي ﷺ: «صيام يوم عاشوراء أحتسب على الله
//أن يكفر السنة التي قبله».
//"""
//                ),
//                CardData(
//                    title: "وقته",
//                    content: """
//يوم عاشوراء هو اليوم العاشر من شهر محرم.
//والأفضل صيامه مع التاسع أو الحادي عشر.
//"""
//                )
//            ]
//            
//        case .shawwal:
//            return [
//                CardData(
//                    title: "حكمه",
//                    content: """
//صيام ستة أيام من شوال بعد عيد الفطر سنة مستحبة.
//يمكن صيامها متتابعة أو متفرقة.
//"""
//                ),
//                CardData(
//                    title: "فضله",
//                    content: """
//قال النبي ﷺ: «من صام رمضان ثم أتبعه ستاً من شوال
//كان كصيام الدهر».
//"""
//                ),
//                CardData(
//                    title: "كيفيته",
//                    content: """
//يُصام بعد عيد الفطر في أي وقت من شهر شوال،
//سواء متتابعة أو متفرقة.
//"""
//                )
//            ]
//        }
//    }
//}



// VIEWMODEL

final class ContentViewModel: ObservableObject {
    @Published var currentIndex: Int = 0

    let topic: NawafilTopic
    let cards: [CardData]

    init(topic: NawafilTopic) {
        self.topic = topic
        self.cards = topic.cards
    }

    var pageTitle: String {
        topic.rawValue
    }
}


// VIEW

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


func sampleCards(for topic: String) -> [CardData] {
    switch topic {
    case "صلاة الضحى":
        return [
            CardData(title: "حكمها", content: "صلاة الضحى سنة أوصى بها النبي ﷺ بعض أصحابه، وفعلها في بعض الأحيان -عليه الصلاة والسلام- وفعلها يوم الفتح، صلى ثمان ركعات الضحى يوم الفتح، فهي سنة مؤكدة."),
            CardData(title: "وقتها", content: "يبدأ وقت صلاة الضحى من ارتفاع الشمس قدر رمح، أي بعد شروق الشمس بنحو ربع ساعة، ويمتد إلى قبيل صلاة الظهر."),
            CardData(title: "عدد ركعاتها", content: "أقلها ركعتان، وأوسطها أربع ركعات، وأفضلها ثمان ركعات، وأكثرها اثنتا عشرة ركعة.")
        ]

    case "قيام الليل":
        return [
            CardData(title: "فضلها", content: "قيام الليل من أفضل النوافل..."),
            CardData(title: "وقتها", content: "يبدأ من بعد العشاء...")
        ]

    default:
        return []
    }
}


#Preview {
    ContentView(topic: .dhuha)
}
