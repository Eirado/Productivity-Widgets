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

    private let todoRepository: TodoRepositoryProtocol
    
    init(todoRepository: TodoRepositoryProtocol) {
        self.todoRepository = todoRepository
    }

    public func createTodo(task: String) async {
        do {
            _ = try await todoRepository.createTodo(task: task)
        } catch {
        }
    }

    public func deleteTodo(todo: Todo, index: Int) async {
        do {
            _ = try await todoRepository.deleteTodo(todo: todo)
        } catch {
        }
    }
}
