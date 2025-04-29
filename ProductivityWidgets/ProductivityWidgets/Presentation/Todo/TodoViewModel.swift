//
//  TodoViewModel.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 25/04/25.
//

import Foundation
import SwiftUI

@Observable
class TodoViewModel {

    var todos: [Todo] = []

    private let todoRepository: TodoRepositoryProtocol
    init(todoRepository: TodoRepositoryProtocol) {
        self.todoRepository = todoRepository

        Task {
//            try await todoRepository.deleteAllTodos()
            await loadAllTodos()
        }
    }

    public var activeTodosCount: String {
            let count = todos.count
            return "(\(count))"
    }

    public func createTodo(task: String) async {
        do {
            let newTodo = try await todoRepository.createTodo(task: task)
            await MainActor.run {
                withAnimation(.snappy) {
                    self.todos.append(newTodo)
                }
            }
        } catch {
        }
    }

    public func deleteTodo(todo: Todo, index: Int) async {
        do {
            _ = try await todoRepository.deleteTodo(todo: todo)
            await MainActor.run {
                withAnimation(.snappy) {
                    self.todos.remove(at: index)
                }
            }
        } catch {
        }
    }

    public func loadAllTodos() async {
        do {
            let loadedTodos = try await todoRepository.fetchAllTodos()
            await MainActor.run {
                withAnimation(.snappy) {
                    self.todos = loadedTodos
                }
            }
        } catch {
        }
    }
}
