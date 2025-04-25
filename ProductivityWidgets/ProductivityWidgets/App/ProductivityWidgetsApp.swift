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
    private let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        do {
            container = try ModelContainer(for: Todo.self)
            
            
        } catch {
            fatalError("Failed to create ModelContainer")
        }
    }
}
