//
//  ModelContainerProvider.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 28/04/25.
//

import SwiftData
import Foundation

@MainActor
final class ModelContainerProvider {
    public let container: ModelContainer
    public let context: ModelContext
    
    static let shared = ModelContainerProvider(useSharedStorage: true)
    
    init(useSharedStorage: Bool = false) {
        do {
            container = try ModelContainer(for: Todo.self)
            context = container.mainContext
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }
}

