//
//  NTabview.swift
//  NawafilApp
//
//  Created by wessal hashim alharbi on 08/02/2026.
//


import SwiftUI

struct NTabview: View {
    
    @State private var selectedTab = 1
    
    var body: some View {
        
        
       TabView(selection: $selectedTab) {

            
           ContentView(
               title: "صلاة الضحى",
               cards: [
                   CardData(title: "حكمها", content: "صلاة الضحى سنة أوصى بها النبي ﷺ بعض أصحابه، وفعلها في بعض الأحيان -عليه الصلاة والسلام- وفعلها يوم الفتح، صلى ثمان ركعات الضحى يوم الفتح، فهي سنة مؤكدة."),
                   CardData(title: "وقتها", content: "يبدأ وقت صلاة الضحى من ارتفاع الشمس قدر رمح، أي بعد شروق الشمس بنحو ربع ساعة، ويمتد إلى قبيل صلاة الظهر."),
                   CardData(title: "عدد ركعاتها", content: "أقلها ركعتان، وأوسطها أربع ركعات، وأفضلها ثمان ركعات، وأكثرها اثنتا عشرة ركعة.")
               ]
           )
                .tabItem{
                 Image("Tracker")
                                   .renderingMode(.template)
                               
                    
                }.tag(0)
            
            
            
           SalahView()
                .tabItem{
                    Image("Kaaba")
                                   .renderingMode(.template)
                               
                    
                }.tag(1)
            
            
            
           Tsbeeh()
                .tabItem{
                    Image("Sebhah")                                   .renderingMode(.template)
                               
                    
                }.tag(2)
            
       
        }
        .tint(buttonColor)

        
        
        
    }
    
    

}

#Preview {
    NTabview()
}
