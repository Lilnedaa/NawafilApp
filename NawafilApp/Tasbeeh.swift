
//
//  Tsbeeh.swift
//  NawafilApp
//
//  Created by wessal hashim alharbi on 03/02/2026.
//



import SwiftUI

struct Tsbeeh: View {
    
    
       let total = 100
    @AppStorage("tasbeeh_count") private var count = 100
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
                      count = 0
                  } label: {
                      Image(systemName: "arrow.counterclockwise")
                          .font(.title2).foregroundStyle(Color(.white))
                          .frame(width: 56, height: 56).background(Color(buttonColor))
                  }
                  .glassEffect()
                  .clipShape(Circle())
                  
                  Button {
                      
                          count += 1
                      
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



struct ProgressRing: View {
    
    var total = 100
    var count : Int
      // 0...1
    var size: CGFloat = 300     // أي حجم
    
    var body: some View {
        let StrokeSize = size * 0.1
        var progress: Double {
               Double(count) / Double(total)
           }
        ZStack {
                 // الخلفية
                 Circle()
                     .stroke(
                         Color.gray.opacity(0.2),
                         lineWidth: StrokeSize
                     )
                 
                 // التقدم
                 Circle()
                     .trim(from: 0, to: progress)
                     .stroke(
                      Color(buttonColor),
                         style: StrokeStyle(
                             lineWidth: StrokeSize,
                             lineCap: .round
                         )
                     )
                     .rotationEffect(.degrees(-90))
                     .animation(.easeInOut, value: count)
                 
         
             }
             .frame(width: size, height: size)
        
        
    }}




#Preview {
    Tsbeeh()
}
//jjjjjjjjjjj
