//
//  TsbeehWidget.swift
//  TsbeehWidget
//
//  Created by wessal hashim alharbi on 10/02/2026.
//

import WidgetKit
import SwiftUI
import AppIntents


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), count: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), count: TasbeehStore.getCount())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, count: TasbeehStore.getCount())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let count: Int
}

struct TsbeehWidgetEntryView : View {
    var entry: Provider.Entry
    private let total = TasbeehStore.total
    
 
    var body: some View {
        ZStack {
               // ✅ نفس ProgressRing حقك
               ProgressRing(
                   total: total,
                   count: entry.count,
                   size: 120
               )

               VStack(spacing: 8) {
                   Text("\(entry.count)")
                       .font(.system(size: 22, weight: .bold))
                       .foregroundStyle(.primary)

                   Button(intent: IncrementTasbeehIntent()) {
                       Image(systemName: "plus")
                           .font(.system(size: 14, weight: .bold))
                           .frame(width: 32, height: 32)
                           .background(.ultraThinMaterial)
                           .clipShape(Circle())
                   }
                   .buttonStyle(.plain)

                   Text("من 100 ذكر")
                       .font(.caption2)
                       .foregroundStyle(.secondary)
               }
           }
           .padding()
           .containerBackground(.background, for: .widget)    }
}

struct TsbeehWidget: Widget {
    let kind: String = "TsbeehWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TsbeehWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TsbeehWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    TsbeehWidget()
} timeline: {
    SimpleEntry(date: .now, count: 0)
    SimpleEntry(date: .now, count: 33)
    SimpleEntry(date: .now, count: 100)


    
}
