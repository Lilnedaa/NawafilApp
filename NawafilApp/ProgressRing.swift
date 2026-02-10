import SwiftUI

struct ProgressRing: View {

    var total: Int = 100
    var count: Int
    var size: CGFloat = 300

    private var safeTotal: Int { max(total, 1) }

    // عدد اللفات الكاملة
    private var loops: Int {
        max(count, 0) / safeTotal
    }

    // التقدم داخل اللفة الحالية
    private var lapProgress: Double {
        let remainder = max(count, 0) % safeTotal
        return Double(remainder) / Double(safeTotal)
    }

    var body: some View {
        let strokeSize = size * 0.12

        ZStack {
            Circle()
                .stroke(
                    Color.white.opacity(0.12),
                    lineWidth: strokeSize
                ).glassEffect()
            if loops > 0 {
                
                ForEach(0..<loops, id: \.self) { _ in
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(
                            Color(buttonColor),
                            style: StrokeStyle(
                                lineWidth: strokeSize,
                                lineCap: .round
                            )
                        )
                        .rotationEffect(.degrees(-90))
                }}

            // 🔹 اللفة الحالية
            Circle()
                .trim(from: 0, to: lapProgress == 0 && loops > 0 ? 1 : lapProgress)
                .stroke(
                    Color(buttonColor),
                    style: StrokeStyle(
                        lineWidth: strokeSize,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .shadow(radius: 6)


        }
        .frame(width: size, height: size)
    }
}
