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
    
    init(useSharedStorage: Bool = false) {
        do {
            if useSharedStorage {
                let appGroupID = "group.GabrielEirado.widgets"
                guard let sharedURL = FileManager
                    .default
                    .containerURL(forSecurityApplicationGroupIdentifier: appGroupID)
                else {
                    fatalError("Unable to access App Group container")
                }
                let url = sharedURL.appendingPathComponent("TodoModel.store")
                let configuration = ModelConfiguration(url: url)
                container = try ModelContainer(
                    for: Todo.self,
                    configurations: configuration
                )
            } else {
                container = try ModelContainer(for: Todo.self)
            }
            context = container.mainContext
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}


