//
//  NawafilLockWidget.swift
//

import WidgetKit
import SwiftUI

// MARK: - App Group Config
enum WidgetEventStore {
    static let suite = "group.com.wessal.nawafil"
    static let eventsKey = "widget_events"

    static func loadEvents() -> [NawafilEvent] {
        guard let ud = UserDefaults(suiteName: suite),
              let data = ud.data(forKey: eventsKey),
              let events = try? JSONDecoder().decode([NawafilEvent].self, from: data)
        else { return [] }
        return events
    }
}

// MARK: - Model (نسخة داخل الويدجت)
struct NawafilEvent: Identifiable, Codable, Equatable {
    let id: String
    let top: String
    let title: String
    let icon: String
}

// MARK: - Timeline Provider (نفس لوجيك تسبيح)
struct NawafilProvider: TimelineProvider {

    func placeholder(in context: Context) -> NawafilEntry {
        NawafilEntry(date: .now,
                     event: .init(id: "sample",
                                  top: "يحدث الآن",
                                  title: "أذكار الصباح",
                                  icon: "sun.max.fill"))
    }

    func getSnapshot(in context: Context, completion: @escaping (NawafilEntry) -> ()) {
        let events = WidgetEventStore.loadEvents()
        let entry = NawafilEntry(date: .now,
                                 event: events.first)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NawafilEntry>) -> ()) {

        let eventsAll = WidgetEventStore.loadEvents()
        let now = Date()

        guard !eventsAll.isEmpty else {
            let entry = NawafilEntry(date: now, event: nil)
            let next = Calendar.current.date(byAdding: .minute, value: 15, to: now)!
            completion(Timeline(entries: [entry], policy: .after(next)))
            return
        }

        // ✅ لو تبين يبدّل "يحدث الآن" فقط:
        let eventsNow = eventsAll.filter { $0.top == "يحدث الآن" }
        let source = eventsNow.isEmpty ? eventsAll : eventsNow

        let stepMinutes = 1   // 👈 خليها 5 لو تبين أكثر ثبات
        let points = 15       // 👈 جدول 15 تحديث قدام

        var entries: [NawafilEntry] = []
        for i in 0..<points {
            let date = Calendar.current.date(byAdding: .minute, value: i * stepMinutes, to: now)!
            let event = source[i % source.count]
            entries.append(NawafilEntry(date: date, event: event))
        }

        let refresh = Calendar.current.date(byAdding: .minute, value: points * stepMinutes, to: now)!
        completion(Timeline(entries: entries, policy: .after(refresh)))
    }

}

// MARK: - Entry
struct NawafilEntry: TimelineEntry {
    let date: Date
    let event: NawafilEvent?
}

// MARK: - View
struct NawafilLockWidgetView: View {
    var entry: NawafilProvider.Entry

    var body: some View {
        ZStack {
            if let event = entry.event {

                HStack(spacing: 8) {

                    Image(systemName: event.icon)
                        .font(.system(size: 18, weight: .semibold))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(event.top)
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)

                        Text(event.title)
                            .font(.system(size: 14, weight: .bold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }

                    Spacer()
                }
                .padding(.horizontal, 8)

            } else {

                Text("لا يوجد حدث الآن")
                    .font(.system(size: 14, weight: .bold))
            }
        }
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

// MARK: - Widget
struct NawafilLockWidget: Widget {

    let kind: String = "NawafilLockWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NawafilProvider()) { entry in

            NawafilLockWidgetView(entry: entry)
        }
        .configurationDisplayName("Nawafil")
        .description("يعرض الحدث الحالي.")
        .supportedFamilies([.accessoryRectangular]) // 👈 هذا للوك سكرين
    }
}

#Preview(as: .accessoryRectangular) {
    NawafilLockWidget()
} timeline: {
    NawafilEntry(date: .now,
                 event: .init(id: "1",
                              top: "يحدث الآن",
                              title: "صيام الخميس",
                              icon: "leaf.fill"))
}
