//
//  ContentViewModel.swift
//  NawafilApp
//
//  Created by Eatzaz Hafiz on 11/02/2026.
//

import SwiftUI
import Combine

final class ContentViewModel: ObservableObject {
    @Published var currentIndex: Int = 0

    let topic: NawafilTopic
    let cards: [CardData]

    init(topic: NawafilTopic) {
        self.topic = topic
        self.cards = topic.cards
    }

    var pageTitle: String {
        topic.rawValue
    }
}


