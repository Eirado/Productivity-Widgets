//
//  TODOEntryViewModel.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 06/05/25.
//

import SwiftData
import Foundation


final class TodoEntryViewModel: ObservableObject {
    public func todoFetchDescrpitor() -> FetchDescriptor<Todo> {
        let predicate = #Predicate<Todo> { _ in true }
        let sort = [SortDescriptor(\Todo.isCompleted, order: .forward),
                    SortDescriptor(\Todo.lastModified, order: .forward)
        ]
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descriptor.fetchLimit = 7
        return descriptor
    }
}
