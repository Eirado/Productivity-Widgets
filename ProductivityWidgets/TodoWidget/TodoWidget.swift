
//  Created by Gabriel Amaral on 24/04/25.


import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

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

struct TodoWidgetRowView: View {
    @Bindable var todo: Todo
    var body: some View {
        HStack {
            Button(intent: toogleTodoTask(id: todo.taskID)) {
                Text(todo.task)
                    .strikethrough(todo.isCompleted)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date = .now
}

struct TODOEntryView : View {
    var entry: Provider.Entry
    
    @Query(todoDescriptor, animation: .smooth) private var todos: [Todo]
    
    var body: some View {
        VStack {
            ForEach(todos) { todo in
                TodoWidgetRowView(todo: todo)
            }
        }
    }
    static var todoDescriptor: FetchDescriptor<Todo> {
        let predicate = #Predicate<Todo> { _ in true }
        let sort = [SortDescriptor(\Todo.isCompleted, order: .forward),
                    SortDescriptor(\Todo.lastModified, order: .forward)
        ]
        let descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        
        return descriptor
    }
}

struct TodoWidget: Widget {
    let kind: String = "TODO"
    
    private let provider = ModelContainerProvider(useSharedStorage: true)
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            TODOEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(provider.container)
        }
        .supportedFamilies([.systemMedium, .systemLarge])
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

struct toogleTodoTask: AppIntent {
    static var title: LocalizedStringResource = .init(stringLiteral: "Toggle's Todo State")
    
    @Parameter(title: "Todo ID")
    var id: String
    
    @Environment(\.modelContext) private var context: ModelContext
    
    init() {
        
    }
    
    init(id: String) {
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        
        let descriptor = FetchDescriptor<Todo>(
            predicate: #Predicate { $0.taskID == id }
        )
        
        if let todo = try context.fetch(descriptor).first {
            todo.isCompleted.toggle()
            try context.save()
        }
        
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
