//
//  ProductivityWidgetsApp.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 24/04/25.
//

import SwiftUI
import SwiftData

@main
struct ProductivityWidgetsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContext(ModelContainerProvider.shared.modelContainer.mainContext)
        }
    }
}
