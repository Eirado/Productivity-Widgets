//
//  ModelContainerProvider.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 28/04/25.
//

import SwiftData
import Foundation

actor ModelContainerProvider {

    static let shared = ModelContainerProvider()
    private init() {}
    
    nonisolated lazy var modelContainer: ModelContainer = {
        let modelContainer: ModelContainer
        do {
            modelContainer = try ModelContainer(for: Todo.self)
        } catch {
            fatalError("Failed to create the model container: \(error)")
        }
        return modelContainer
    }()
}

