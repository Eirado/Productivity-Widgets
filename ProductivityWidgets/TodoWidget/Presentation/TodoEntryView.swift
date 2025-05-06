//
//  TODOEntryView.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 06/05/25.
//

import SwiftUI
import SwiftData


struct TodoEntryView : View {
    
    @Query(todoDescriptor, animation: .snappy) private var todos: [Todo]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            ForEach(todos) { todo in
                TodoWidgetRowView(todo: todo)
            }
            Spacer()
        }
        .containerBackground(.black, for: .widget)
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
