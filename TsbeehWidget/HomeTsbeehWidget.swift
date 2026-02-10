//
//  HomeTsbeehWidget.swift
//  NawafilApp
//
//  Created by wessal hashim alharbi on 10/02/2026.
//

import WidgetKit
import SwiftUI
import AppIntents

struct PlusProvider: TimelineProvider {
    func placeholder(in context: Context) -> PlusEntry {
        PlusEntry(date: Date(), count: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (PlusEntry) -> ()) {
        completion(PlusEntry(date: Date(), count: TasbeehStore.getCount()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PlusEntry>) -> ()) {
        let entry = PlusEntry(date: Date(), count: TasbeehStore.getCount())
        completion(Timeline(entries: [entry], policy: .never))
    }
}

struct PlusEntry: TimelineEntry {
    let date: Date
    let count: Int
}

struct TsbeehPlusWidgetEntryView: View {
    var entry: PlusEntry

    var body: some View {
        VStack(spacing: 12) {
            Text("\(entry.count)")
                .font(.system(size: 34, weight: .bold))

            Button(intent: IncrementTasbeehIntent()) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("زيادة")
                }
                .font(.system(size: 16, weight: .semibold))
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
        }
        .padding()
        .containerBackground(.background, for: .widget)
    }
}

struct HomeTsbeehWidget: Widget {
    let kind: String = "TsbeehPlusWidget" // لازم مختلف عن TsbeehWidget

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PlusProvider()) { entry in
            TsbeehPlusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Tsbeeh +")
        .description("زر يزيد العداد مباشرة.")
        .supportedFamilies([.systemSmall])
    }
}
