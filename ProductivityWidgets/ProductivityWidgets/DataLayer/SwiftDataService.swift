//
//  SwiftDataRepository.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 25/04/25.
//

import Foundation
import SwiftData

public protocol TodoRepositoryProtocol {
    func createTodo(task: String) async throws
    func fetchAllTodos() async throws -> [Todo]
    func fetchUncompletedTodos() async throws -> [Todo]
    func fetchRecentCompletedTodos() async throws -> [Todo]
}

@MainActor
final class TodoRepository: TodoRepositoryProtocol {
    weak private var context: ModelContext?

    init(context: ModelContext) {
        self.context = context
    }

    public func createTodo(task: String) async throws {
        let newTodo = Todo(
            taskID: UUID().uuidString,
            task: task, isCompleted: false,
            priority: .medium,
            lastModified: .now
        )
        guard let context = context else {
            return
        }
        context.insert(newTodo)
        try context.save()
        print(newTodo)
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
