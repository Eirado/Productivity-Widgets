//
//  TodoViewModel.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 25/04/25.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class TodoViewModel {
    
    public var lastAddedTodoID: PersistentIdentifier?
    
    @ObservationIgnored
    private let todoRepository: TodoRepositoryProtocol
    
    
    init(todoRepository: TodoRepositoryProtocol) {
        self.todoRepository = todoRepository
    }
    
    public func createTodo(task: String) async {
        if task.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        do {
            let newTodo = try await todoRepository.createTodo(task: task)
            updateLastAddedTodoID(with: newTodo.id)
        } catch {
        }
    }
    
    public func deleteTodo(todo: Todo, index: Int) async {
        do {
            _ = try await todoRepository.deleteTodo(todo: todo)
        } catch {
        }
    }
    
    public func smoothlyScrollToNewItem(proxy: ScrollViewProxy, todoID: PersistentIdentifier, isLast: Bool) {
        if isLast {
            
        }
        
        withAnimation(.smooth(duration: 0.3).delay(0.1)) {
            proxy.scrollTo(todoID, anchor: .center)
        }
    }
}

private extension TodoViewModel {
    func updateLastAddedTodoID(with id: PersistentIdentifier) {
        self.lastAddedTodoID = id
    }
}
