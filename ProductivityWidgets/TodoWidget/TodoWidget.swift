
//  Created by Gabriel Amaral on 24/04/25.


import WidgetKit
import SwiftUI
import SwiftData


struct Provider: AppIntentTimelineProvider {
    
    func placeholder(in context: Context) -> TodoEntry {
        TodoEntry()
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> TodoEntry {
        TodoEntry()
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<TodoEntry> {
        return Timeline(entries: [TodoEntry()], policy: .never)
    }
}


struct TodoEntry: TimelineEntry {
    let date: Date = .now
}

struct TodoWidget: Widget {
    let kind: String = "TODO"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { _ in
            TodoEntryView()
                .modelContainer(ModelContainerProvider.shared.modelContainer)
        }
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}
