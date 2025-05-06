//
//  AppIntent.swift
//
//  Created by Gabriel Amaral on 24/04/25.
//

import WidgetKit
import AppIntents
import SwiftData

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}


struct ToggleTodoTask: AppIntent {
    static var title: LocalizedStringResource = .init(stringLiteral: "Toggle's Todo State")
    
    @Parameter(title: "Todo ID")
    var id: String
    
    init() {
        
    }
    
    init(id: String) {
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        let modelContext = ModelContext(ModelContainerProvider.shared.modelContainer)
        
        let descriptor = FetchDescriptor<Todo>(
            predicate: #Predicate { $0.taskID == id }
        )
        
        if let todo = try modelContext.fetch(descriptor).first {
            todo.isCompleted.toggle()
            try modelContext.save()
            WidgetCenter.shared.reloadTimelines(ofKind: "TODO")
        }
        
        return .result()
    }
}
