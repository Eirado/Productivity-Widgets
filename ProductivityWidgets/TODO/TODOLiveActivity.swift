//
//  TODOLiveActivity.swift
//  TODO
//
//  Created by Gabriel Amaral on 24/04/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TODOAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TODOLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TODOAttributes.self) { context in
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

extension TODOAttributes {
    fileprivate static var preview: TODOAttributes {
        TODOAttributes(name: "World")
    }
}

extension TODOAttributes.ContentState {
    fileprivate static var smiley: TODOAttributes.ContentState {
        TODOAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TODOAttributes.ContentState {
         TODOAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TODOAttributes.preview) {
   TODOLiveActivity()
} contentStates: {
    TODOAttributes.ContentState.smiley
    TODOAttributes.ContentState.starEyes
}
