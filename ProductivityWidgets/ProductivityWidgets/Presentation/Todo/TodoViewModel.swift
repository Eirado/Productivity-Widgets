//
//  TodoViewModel.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 25/04/25.
//

import Foundation

 class TodoViewModel: ObservableObject {

    private let todoRepository: TodoRepositoryProtocol

    init(todoRepository: TodoRepositoryProtocol) {
        self.todoRepository = todoRepository
    }

}
