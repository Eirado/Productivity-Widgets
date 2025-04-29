//
//  TodoViewModel.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 25/04/25.
//

import Foundation
import SwiftUI

@Observable
class TodoViewModel: ObservableObject {
    
    var todos: [Todo] = []

    private let todoRepository: TodoRepositoryProtocol
    init(todoRepository: TodoRepositoryProtocol) {
        self.todoRepository = todoRepository
        
        Task {
//            try await todoRepository.deleteAllTodos()
            await loadActiveTodos()
        }
        
        
    }
    
    public var activeTodosCount: String {
        get {
            let count = todos.count
            return "(\(count))"
        }
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
    
    public func deleteTodo(todo: Todo) async {
        do {
            let deletedTodo = try await todoRepository.deleteTodo(todo: todo)
            await MainActor.run {
                withAnimation(.snappy) {
                    self.todos.removeAll { $0.id == todo.id }
                }
            }
        } catch{
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
                withAnimation(.snappy) {
                    self.todos = loadedTodos
                }
            }
        } catch {
        }
    }
}
