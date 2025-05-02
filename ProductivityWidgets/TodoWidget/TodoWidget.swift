
//  Created by Gabriel Amaral on 24/04/25.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry()
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry()
    }
    
    
    // provide updates -> mine is input based
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        
        var entries: [SimpleEntry] = []
        
        let entry = SimpleEntry()
        entries.append(entry)

        // never will refresh the
        return Timeline(entries: entries, policy: .never)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date = .now
}

struct TODOEntryView : View {
    var entry: Provider.Entry
    
    @Query(todoDescriptor, animation: .smooth) private var todos: [Todo]
    
    var body: some View {
        VStack {
           
        }
    }
    static var todoDescriptor: FetchDescriptor<Todo> {
        let predicate = #Predicate<Todo> { _ in true }
        let sort =  [SortDescriptor(\Todo.isCompleted, order: .forward),
            SortDescriptor(\Todo.lastModified, order: .forward)
        ]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descriptor.fetchLimit = 3
        return descriptor
    }
}

struct TodoWidget: Widget {
    let kind: String = "TODO"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            TODOEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
            
                .modelContainer(for: Todo.self)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
}

#Preview(as: .systemSmall) {
    TodoWidget()
} timeline: {
    SimpleEntry()
}
