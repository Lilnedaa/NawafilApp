//
//  nawafilEventStore.swift
//  NawafilApp
//
//  Created by wessal hashim alharbi on 12/02/2026.
//

import Foundation

enum NawafilEventStore {

    static let suite = "group.com.wessal.nawafil"
    private static let eventsKey = "widget_events"

    private static var defaults: UserDefaults {
        guard let d = UserDefaults(suiteName: suite) else {
            fatalError("App Group not configured for suite: \(suite)")
        }
        return d
    }

    static func saveEvents(_ events: [NawafilEvent]) {
        if let data = try? JSONEncoder().encode(events) {
            defaults.set(data, forKey: eventsKey)
        }
    }

    static func getEvents() -> [NawafilEvent] {
        guard let data = defaults.data(forKey: eventsKey),
              let events = try? JSONDecoder().decode([NawafilEvent].self, from: data)
        else { return [] }

        return events
    }
}
