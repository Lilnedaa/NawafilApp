//
//  ProgressRing.swift
//  NawafilApp
//
//  Created by wessal hashim alharbi on 09/02/2026.
//

import SwiftUI


struct ProgressRing: View {
    
    var total = 100
    var count: Int
    var size: CGFloat = 300

    private var progress: Double {
        min(Double(count) / Double(total), 1.0)
    }


    var body: some View {
        let strokeSize = size * 0.1

        ZStack {
            Circle()
                .stroke(
                    Color.gray.opacity(0.2),
                    lineWidth: strokeSize
                )

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color(buttonColor),
                    style: StrokeStyle(
                        lineWidth: strokeSize,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
        .frame(width: size, height: size)
    }
}
