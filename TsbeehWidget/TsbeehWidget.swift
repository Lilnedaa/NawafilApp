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
        SimpleEntry(date: Date(), count: 0 , total: 100)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), count: TasbeehStore.getCount() , total: TasbeehStore.getTotal())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = SimpleEntry(date: .now,
                                count: TasbeehStore.getCount(),
                                total: TasbeehStore.getTotal())
        completion(Timeline(entries: [entry], policy: .never))
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let count: Int
    let total: Int

}

struct TsbeehWidgetEntryView : View {
    var entry: Provider.Entry
    
 
    var body: some View {
        Button(intent: IncrementTasbeehIntent()) {
            VStack {
                ZStack {
                    ProgressRing(total: entry.total, count: entry.count, size: 100)

                    Text("\(entry.count)")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.primary)
                }

                Spacer()
            }
            .padding()
        }
        .buttonStyle(.plain)
        .containerBackground(for: .widget) {
            backgroundColor
        }
    }
            
            
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
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    TsbeehWidget()
} timeline: {
    SimpleEntry(date: .now, count: 0 , total: 10)
    SimpleEntry(date: .now, count: 33 , total: 100)
    SimpleEntry(date: .now, count: 100, total: 1000)


    
}
