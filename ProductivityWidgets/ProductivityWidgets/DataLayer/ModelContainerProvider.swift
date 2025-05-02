//
//  ModelContainerProvider.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 28/04/25.
//

import SwiftData

@MainActor
final class ModelContainerProvider {
    private let container: ModelContainer
    public let context: ModelContext
    init() {
        do {
            
            container = try ModelContainer(for: Todo.self)
            context = container.mainContext
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }
}
