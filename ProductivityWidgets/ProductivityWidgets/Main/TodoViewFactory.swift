//
//  TodoViewFactory.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 28/04/25.
//

import SwiftData
import SwiftUI

@MainActor
final class TodoViewFactory {
    static public func makeTodoView(size: CGSize, safeArea: EdgeInsets, context: ModelContext) -> TodoView {
        let repository = TodoRepository(context: context)
        let viewModel = TodoViewModel(todoRepository: repository)
        return TodoView(size: size, safeArea: safeArea, viewModel: viewModel)
    }
}
