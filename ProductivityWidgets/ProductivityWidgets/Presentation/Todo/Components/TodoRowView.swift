//
//  TodoRowView.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 29/04/25.
//

import SwiftUI
import WidgetKit
// SHOULD GET BIGGER WHEN HAS A BIT TEXT
// SHOULD BE EDITED WITH A SHEET
struct TodoRowView: View, Equatable{
    
    static func == (lhs: TodoRowView, rhs: TodoRowView) -> Bool {
        lhs._todo.id == rhs._todo.id
    }
    
    @Bindable var todo: Todo
    @Environment(\.modelContext) private var context
    
    var body: some View {
        HStack(spacing: 8) {
            Button {
                withAnimation(.snappy) {
                    todo.isCompleted.toggle()
                    WidgetCenter.shared.reloadAllTimelines()
                }
            } label: {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .padding(3)
                    .contentShape(.rect)
                    .foregroundStyle(todo.isCompleted ? .gray : .primary)
            }
            TextField("", text: $todo.task, axis: .vertical)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .gray : .primary)
                .font(.interItalic(fontweight: .regular, fontStyle: .body))
            
        }
        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button("", systemImage: "trash") {
                context.delete(todo)
                WidgetCenter.shared.reloadAllTimelines()
            }
            .tint(.red)
        }
    }
}

#Preview {
    TodoViewFactory.makeTodoView(
        size: DevicePreview.iPhone16Pro.size,
        safeArea: DevicePreview.iPhone16Pro.safeArea,
        context: ModelContainerProvider.shared.modelContainer.mainContext
    )
}
