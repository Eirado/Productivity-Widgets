//
//  SwiftDataRepository.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 25/04/25.
//

import Foundation
import SwiftData

enum PersistenceError: Error {
    case contextError
}

public protocol TodoRepositoryProtocol {
    func createTodo(task: String) async throws -> Todo
    func fetchAllTodos() async throws -> [Todo]
    func fetchUncompletedTodos() async throws -> [Todo]
    func fetchRecentCompletedTodos() async throws -> [Todo]
    func deleteTodo(todo: Todo) async throws -> String
    func deleteAllTodos() async throws
}

@MainActor
final class TodoRepository: TodoRepositoryProtocol {
    weak private var context: ModelContext?

    init(context: ModelContext) {
        self.context = context
    }

    public func createTodo(task: String) async throws -> Todo {
        guard let context = context else {
            throw PersistenceError.contextError
        }
        let newTodo = Todo(
            taskID: UUID().uuidString,
            task: task, isCompleted: false,
            priority: .medium,
            lastModified: .now
        )
        context.insert(newTodo)
        try context.save()
        return newTodo
    }

    public func deleteTodo(todo: Todo) async throws -> String {
        guard let context = context else {
            throw PersistenceError.contextError
        }
        context.delete(todo)
        try context.save()
        return todo.taskID
    }

    public func deleteAllTodos() async throws {
        guard let context = context else {
            throw PersistenceError.contextError
        }
            let fetchDescriptor = FetchDescriptor<Todo>(predicate: #Predicate<Todo> { _ in true })
            let todos = try context.fetch(fetchDescriptor)
            for todo in todos {
                context.delete(todo)
            }
            try context.save()
        }

    public func fetchAllTodos() async throws -> [Todo] {
        guard let context = context else {
            return []
        }
        let descriptor = FetchDescriptor( predicate: #Predicate<Todo> { _ in true })
        let allTodos = try context.fetch(descriptor)
        return allTodos
    }

    public func fetchRecentCompletedTodos() async throws -> [Todo] {
        guard let context = context else {
            return []
        }
        let predicate =  #Predicate<Todo> { $0.isCompleted == true }
        let sort = [SortDescriptor(\Todo.lastModified, order: .reverse)]
        var recentCompletedTodosDescriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        recentCompletedTodosDescriptor.fetchLimit = 15
        let recentCompletedTodos = try context.fetch(recentCompletedTodosDescriptor)
        return recentCompletedTodos
    }

    public func fetchUncompletedTodos() async throws -> [Todo] {
        guard let context = context else {
            return []
        }
        let predicate =  #Predicate<Todo> { $0.isCompleted == false }
        let sort = [SortDescriptor(\Todo.lastModified, order: .reverse)]
        let notCompletedDescriptor =
        FetchDescriptor(predicate: predicate, sortBy: sort)
        let activeList = try context.fetch(notCompletedDescriptor)
        return activeList
    }
}
