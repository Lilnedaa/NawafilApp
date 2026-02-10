//
//  ContentModel.swift
//  NawafilApp
//
//  Created by Eatzaz Hafiz on 11/02/2026.
//

import SwiftUI
import Foundation


struct CardData: Identifiable {
    let id = UUID()
    let title: String
    let content: String
}

enum NawafilTopic: String, CaseIterable, Identifiable {
    // Prayer topics
    case dhuha = "صلاة الضحى"
    case qiyam = "قيام الليل"
    case sunnahFajr = "سنة الفجر"
    case sunnahDhuhr = "سنة الظهر"
    case sunnahMaghrib = "سنة المغرب"
    case sunnahIsha = "سنة العشاء"
    
    // Fasting topics
    case mondayThursday = "صيام الاثنين والخميس"
    case whiteDays = "صيام الأيام البيض"
    case arafah = "صيام يوم عرفة"
    case ashura = "صيام يوم عاشوراء"
    case shawwal = "صيام ستة من شوال"

    var id: String { rawValue }

    var cards: [CardData] {
        switch self {

        // PRAYER TOPICS
        case .dhuha:
            return [
                CardData(
                    title: "حكمها",
                    content: """
صلاة الضحى سنة مؤكدة، أوصى بها النبي ﷺ بعض أصحابه،
وفعلها في بعض الأحيان، وصلاها يوم فتح مكة ثمان ركعات.
"""
                ),
                CardData(
                    title: "وقتها",
                    content: """
يبدأ وقت صلاة الضحى من ارتفاع الشمس قدر رمح
أي بعد الشروق بنحو ربع ساعة، ويمتد إلى قبيل الظهر.
"""
                ),
                CardData(
                    title: "عدد ركعاتها",
                    content: """
أقلها ركعتان، وأوسطها أربع ركعات،
وأفضلها ثمان ركعات، وأكثرها اثنتا عشرة ركعة.
"""
                )
            ]

        case .qiyam:
            return [
                CardData(
                    title: "فضلها",
                    content: """
قيام الليل من أفضل النوافل،
وهو دأب الصالحين وقربة إلى الله تعالى.
"""
                ),
                CardData(
                    title: "وقته",
                    content: """
يبدأ من بعد صلاة العشاء،
ويمتد إلى طلوع الفجر، وأفضله الثلث الأخير من الليل.
"""
                ),
                CardData(
                    title: "كيفيتها",
                    content: """
تصلى ركعتين ركعتين، ويُستحب أن يختمها بالوتر.
والأفضل إحدى عشرة ركعة أو ثلاث عشرة ركعة.
"""
                )
            ]
            
        case .sunnahFajr:
            return [
                CardData(
                    title: "حكمها",
                    content: """
سنة الفجر ركعتان قبل صلاة الفجر،
وهي من أكثر السنن تأكيداً ولم يكن النبي ﷺ يتركها.
"""
                ),
                CardData(
                    title: "فضلها",
                    content: """
قال النبي ﷺ: «ركعتا الفجر خير من الدنيا وما فيها».
"""
                ),
                CardData(
                    title: "وقتها",
                    content: """
تصلى بعد دخول وقت الفجر وقبل صلاة الفجر المفروضة.
"""
                )
            ]
            
        case .sunnahDhuhr:
            return [
                CardData(
                    title: "حكمها",
                    content: """
سنة الظهر أربع ركعات قبل الصلاة وركعتان بعدها.
وهي من السنن الراتبة.
"""
                ),
                CardData(
                    title: "فضلها",
                    content: """
من حافظ على أربع ركعات قبل الظهر وأربع بعدها
حرمه الله على النار.
"""
                ),
                CardData(
                    title: "كيفيتها",
                    content: """
تصلى أربع ركعات قبل الظهر بتسليمتين،
وركعتان بعد الظهر.
"""
                )
            ]
            
        case .sunnahMaghrib:
            return [
                CardData(
                    title: "حكمها",
                    content: """
سنة المغرب ركعتان بعد صلاة المغرب.
وهي من السنن الراتبة.
"""
                ),
                CardData(
                    title: "وقتها",
                    content: """
تصلى بعد صلاة المغرب مباشرة.
"""
                ),
                CardData(
                    title: "فضلها",
                    content: """
من صلى السنن الراتبة بنى الله له بيتاً في الجنة.
"""
                )
            ]
            
        case .sunnahIsha:
            return [
                CardData(
                    title: "حكمها",
                    content: """
سنة العشاء ركعتان بعد صلاة العشاء.
وهي من السنن الراتبة.
"""
                ),
                CardData(
                    title: "فضلها",
                    content: """
هي من السنن الراتبة التي حث عليها النبي ﷺ
ومن حافظ عليها بنى الله له بيتاً في الجنة.
"""
                ),
                CardData(
                    title: "وقتها",
                    content: """
تصلى بعد صلاة العشاء المفروضة مباشرة.
"""
                )
            ]
            
        // FASTING TOPICS
        case .mondayThursday:
            return [
                CardData(
                    title: "حكمه",
                    content: """
صيام يومي الاثنين والخميس من كل أسبوع سنة مستحبة.
كان النبي ﷺ يتحرى صيامهما.
"""
                ),
                CardData(
                    title: "فضله",
                    content: """
قال النبي ﷺ: «تُعرض الأعمال يوم الاثنين والخميس
فأحب أن يُعرض عملي وأنا صائم».
"""
                ),
                CardData(
                    title: "سبب الفضل",
                    content: """
تُرفع الأعمال إلى الله في هذين اليومين،
فيحب المسلم أن يُرفع عمله وهو صائم.
"""
                )
            ]
            
        case .whiteDays:
            return [
                CardData(
                    title: "حكمه",
                    content: """
صيام الأيام البيض هو صيام الأيام ١٣ و١٤ و١٥ من كل شهر قمري.
وهو سنة مستحبة.
"""
                ),
                CardData(
                    title: "فضله",
                    content: """
قال النبي ﷺ: «صيام ثلاثة أيام من كل شهر
صيام الدهر كله».
"""
                ),
                CardData(
                    title: "سبب التسمية",
                    content: """
سميت بالأيام البيض لأن القمر يكون بدراً فيها
فتكون الليالي بيضاء مضيئة.
"""
                )
            ]
            
        case .arafah:
            return [
                CardData(
                    title: "حكمه",
                    content: """
صيام يوم عرفة سنة مؤكدة لغير الحاج.
أما الحاج فالأفضل له الفطر.
"""
                ),
                CardData(
                    title: "فضله",
                    content: """
قال النبي ﷺ: «صيام يوم عرفة أحتسب على الله
أن يكفر السنة التي قبله والسنة التي بعده».
"""
                ),
                CardData(
                    title: "وقته",
                    content: """
يوم عرفة هو اليوم التاسع من شهر ذي الحجة.
وهو من أفضل أيام السنة.
"""
                )
            ]
            
        case .ashura:
            return [
                CardData(
                    title: "حكمه",
                    content: """
صيام يوم عاشوراء سنة مؤكدة.
ويُستحب صيام يوم قبله أو بعده.
"""
                ),
                CardData(
                    title: "فضله",
                    content: """
قال النبي ﷺ: «صيام يوم عاشوراء أحتسب على الله
أن يكفر السنة التي قبله».
"""
                ),
                CardData(
                    title: "وقته",
                    content: """
يوم عاشوراء هو اليوم العاشر من شهر محرم.
والأفضل صيامه مع التاسع أو الحادي عشر.
"""
                )
            ]
            
        case .shawwal:
            return [
                CardData(
                    title: "حكمه",
                    content: """
صيام ستة أيام من شوال بعد عيد الفطر سنة مستحبة.
يمكن صيامها متتابعة أو متفرقة.
"""
                ),
                CardData(
                    title: "فضله",
                    content: """
قال النبي ﷺ: «من صام رمضان ثم أتبعه ستاً من شوال
كان كصيام الدهر».
"""
                ),
                CardData(
                    title: "كيفيته",
                    content: """
يُصام بعد عيد الفطر في أي وقت من شهر شوال،
سواء متتابعة أو متفرقة.
"""
                )
            ]
        }
    }
}
