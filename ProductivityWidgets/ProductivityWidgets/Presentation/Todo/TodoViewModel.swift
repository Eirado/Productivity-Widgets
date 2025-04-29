//
//  TodoViewModel.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 25/04/25.
//

import Foundation
import SwiftUI

class TodoViewModel: ObservableObject {

    private let todoRepository: TodoRepositoryProtocol

    @Published var todos: [Todo] = []
    
    public var activeTodosCount: String {
        get {
            let count = todos.count
            return count == 0 ? "Active": "Active (\(count))"
        }
    }

    init(todoRepository: TodoRepositoryProtocol) {
        self.todoRepository = todoRepository
        Task {
            await loadActiveTodos()
        }
    }

    public func createTodo(task: String) async {
        do {
            try await todoRepository.createTodo(task: task)
        } catch {
        }
    }

    public func loadActiveTodos() async {
        do {
            let loadedTodos = try await todoRepository.fetchUncompletedTodos()
            await MainActor.run {
                withAnimation(.snappy) {
                    self.todos = loadedTodos
                }
            }
        } catch {
        }
    }
    
    public func loadRecentTodos() async {
        do {
            let loadedTodos = try await todoRepository.fetchUncompletedTodos()
            await MainActor.run {
                withAnimation(.snappy){
                    self.todos = loadedTodos
                }
            }
        } catch {
        }
    }
}
