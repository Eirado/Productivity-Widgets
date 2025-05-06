//
//  TODOBundle.swift
//  TODO
//
//  Created by Gabriel Amaral on 24/04/25.
//

import WidgetKit
import SwiftUI
import SwiftData

@main
struct TodoBundle: WidgetBundle {
    private let modelContainer = ModelContainerProvider()
    var body: some Widget {
        TodoWidget()
        TodoControl()
    }
}
