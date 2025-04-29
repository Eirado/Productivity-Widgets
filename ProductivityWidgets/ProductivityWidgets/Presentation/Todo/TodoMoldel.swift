//
//  TodoMoldel.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 25/04/25.
//

import SwiftData
import Foundation
import SwiftUICore

@Model
public class Todo {
    private(set) var taskID: String = UUID().uuidString
    var task: String
    var isCompleted: Bool = false
    var priority: TaskPriority = TaskPriority.medium
    var lastModified: Date = Date.now

    init(taskID: String, task: String, isCompleted: Bool, priority: TaskPriority, lastModified: Date) {
        self.taskID = taskID
        self.task = task
        self.isCompleted = isCompleted
        self.priority = priority
        self.lastModified = lastModified
    }
}

enum TaskPriority: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    var color: Color {
        switch self {
        case .low:
                .green
        case .medium:
                .yellow
        case .high:
                .red
        }
    }
}
