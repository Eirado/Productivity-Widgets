//
//  TodoRowView.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 29/04/25.
//

import SwiftUI

struct TodoRowView: View {
    @Bindable var todo: Todo
    @Environment(\.modelContext) private var context
    @FocusState var isRowActive
    
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
            TextField("", text: $todo.task)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .gray : .primary)
                .focused($isRowActive)
                .onSubmit {
                    if todo.task.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        context.delete(todo)
                    }
                }
        }
        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        .onAppear {
            isRowActive = todo.task.isEmpty
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button("", systemImage: "trash") {
                context.delete(todo)
            }
            .tint(.red)
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
