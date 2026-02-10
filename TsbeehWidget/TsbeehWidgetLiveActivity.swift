//
//  TsbeehWidgetLiveActivity.swift
//  TsbeehWidget
//
//  Created by wessal hashim alharbi on 10/02/2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TsbeehWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TsbeehWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TsbeehWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TsbeehWidgetAttributes {
    fileprivate static var preview: TsbeehWidgetAttributes {
        TsbeehWidgetAttributes(name: "World")
    }
}

extension TsbeehWidgetAttributes.ContentState {
    fileprivate static var smiley: TsbeehWidgetAttributes.ContentState {
        TsbeehWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TsbeehWidgetAttributes.ContentState {
         TsbeehWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TsbeehWidgetAttributes.preview) {
   TsbeehWidgetLiveActivity()
} contentStates: {
    TsbeehWidgetAttributes.ContentState.smiley
    TsbeehWidgetAttributes.ContentState.starEyes
}
