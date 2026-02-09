//
//  ProgressRing.swift
//  NawafilApp
//
//  Created by wessal hashim alharbi on 09/02/2026.
//

import SwiftUI

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


