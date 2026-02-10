//
//  tt.swift
//  NawafilApp
//
//  Created by wessal hashim alharbi on 10/02/2026.
//

import Foundation

enum TasbeehStore {
    static let suite = "group.com.wessal.nawafil"
    static let key = "tasbeeh_count"
    static let total = 100

    private static var defaults: UserDefaults {
        UserDefaults(suiteName: suite) ?? .standard
    }

    static func getCount() -> Int {
        defaults.integer(forKey: key)
    }

    static func setCount(_ value: Int) {
        defaults.set(value, forKey: key)
    }

    static func increment() {
        let current = getCount()
        let next = current + 1
        setCount(next)
    }

    static func reset() {
        setCount(0)
    }
}
