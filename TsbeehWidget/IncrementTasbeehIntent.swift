//
//  Untitled.swift
//  NawafilApp
//
//  Created by wessal hashim alharbi on 10/02/2026.
//

import AppIntents
import WidgetKit

struct IncrementTasbeehIntent: AppIntent {
    static var title: LocalizedStringResource = "Increase Tasbeeh"

    func perform() async throws -> some IntentResult {
        TasbeehStore.increment()
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

struct ResetTasbeehIntent: AppIntent {
    static var title: LocalizedStringResource = "Reset Tasbeeh"

    func perform() async throws -> some IntentResult {
        TasbeehStore.reset()
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
