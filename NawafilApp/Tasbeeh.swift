
//
//  Tsbeeh.swift
//  NawafilApp
//
//  Created by wessal hashim alharbi on 03/02/2026.
//



import SwiftUI
import WidgetKit

struct Tsbeeh: View {
    
    
       let total = 100
    @AppStorage("tasbeeh_count", store: UserDefaults(suiteName: "group.com.wessal.nawafil"))
    private var count: Int = 0
    var progress: Double {
           Double(count) / Double(total)
       }
    
    var body: some View {
        VStack{
            
            // clander
            
            
           TasbeehCalendarPage(count: $count, total: total)
            
            ZStack {

                                ProgressRing(total: total,count: count, size: 300)

                   //   النص
                     VStack(spacing: 8) {
                         Text("\(count)")
                             .font(.system(size: 42, weight: .bold)).foregroundStyle(Color(textColor))
                         
                         Text("من 100 ذكر")
                             .font(.caption)
                             .foregroundColor(.gray)
                     }
                 }
            
            
            
            // الأزرار
              HStack(spacing: 200) {
                  Button {
                      TasbeehStore.reset()
                      WidgetCenter.shared.reloadAllTimelines()

                  } label: {
                      Image(systemName: "arrow.counterclockwise")
                          .font(.title2).foregroundStyle(Color(.white))
                          .frame(width: 56, height: 56).background(Color(buttonColor))
                  }
                  .glassEffect()
                  .clipShape(Circle())
                  
                  Button {
                      
                      TasbeehStore.increment()
                      WidgetCenter.shared.reloadAllTimelines()


                  } label: {
                      Image(systemName: "plus")
                          .font(.title2).foregroundStyle(Color(.white))
                          .frame(width: 56, height: 56).background(Color(buttonColor))
                  }.glassEffect()
                .clipShape(Circle())
                  
                  
                

              }
            
          }


            
        }
    }






#Preview {
    Tsbeeh()
}
//jjjjjjjjjjj
