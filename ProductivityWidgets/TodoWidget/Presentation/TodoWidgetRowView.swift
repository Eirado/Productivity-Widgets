//
//  TodoWidgetRowView.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 06/05/25.
//

import SwiftUI

struct TodoWidgetRowView: View {
    @Bindable var todo: Todo
    var body: some View {
        HStack() {
            Button(intent: ToggleTodoTask(id: todo.taskID)) {
                Text(todo.task)
                    .strikethrough(todo.isCompleted)
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal, -15)
            }
            .buttonStyle(.borderless)
            Spacer()
        }
    }
}
