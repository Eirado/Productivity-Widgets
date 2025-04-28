//
//  SwiftDataRepository.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 25/04/25.
//

import Foundation
import SwiftData

public protocol TodoRepositoryProtocol {
    func create(task: String) async throws
}

@MainActor
final class TodoRepository: TodoRepositoryProtocol {
    weak private var context: ModelContext?

    init(context: ModelContext) {
        self.context = context
    }

    public func create(task: String) async throws {
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
    }
}
