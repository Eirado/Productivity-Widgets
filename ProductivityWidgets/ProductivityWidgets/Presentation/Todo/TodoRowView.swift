//
//  TodoRowView.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 29/04/25.
//

import SwiftUI

struct TodoRowView: View {
    @Bindable var todo: Todo
    @FocusState private var isRowActive: Bool
    @Environment(\.modelContext) private var context
    
    @Bindable var contentModel: TodoViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            Button {
                todo.isCompleted.toggle()
            } label: {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .padding(3)
                    .contentShape(.rect)
                    .foregroundStyle(todo.isCompleted ? .gray : .primary)
                    .contentTransition(.symbolEffect(.replace))
            }
            TextField("Record Video", text: $todo.task)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .gray : .primary)
                .focused($isRowActive)
        }
        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        .animation(.snappy, value: isRowActive)
        .onAppear {
            isRowActive = todo.task.isEmpty
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button("", systemImage: "trash") {
                Task {
                    await contentModel.deleteTodo(todo: todo)
                }
            }
            .tint(.red)
        }
        .onSubmit(of: .text) {
            if todo.task.isEmpty {
                Task {
                    await contentModel.deleteTodo(todo: todo)
                }
            }
        }
    }
}

#Preview {
    TodoViewFactory.makeTodoView(
        size: DevicePreview.iPhone16Pro.size,
        safeArea: DevicePreview.iPhone16Pro.safeArea,
        context: ModelContainerProvider().context
    )
}
