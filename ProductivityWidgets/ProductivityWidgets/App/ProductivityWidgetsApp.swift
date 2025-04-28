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
    private let modelContainer = ModelContainerProvider()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContext(modelContainer.context)
        }
    }
}
