//
//  TsbeehWidgetBundle.swift
//  TsbeehWidget
//
//  Created by wessal hashim alharbi on 10/02/2026.
//

import WidgetKit
import SwiftUI

@main
struct TsbeehWidgetBundle: WidgetBundle {
    var body: some Widget {
        TsbeehWidget()
        TsbeehWidgetControl()
        TsbeehWidgetLiveActivity()
    }
}
