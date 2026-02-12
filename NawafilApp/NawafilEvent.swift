//
//  NawafilEvent.swift
//  NawafilApp
//
//  Created by Rana on 23/08/1447 AH.
//

import Foundation


struct NawafilEvent: Identifiable, Equatable, Codable {

    let id: String
    let top: String
    let title: String
    let icon: String

    init(id: String? = nil, top: String, title: String, icon: String) {
        self.id = id ?? "\(title)_\(icon)"
        self.top = top
        self.title = title
        self.icon = icon
    }
}
