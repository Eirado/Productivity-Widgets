//
//  TODOEntryView.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 06/05/25.
//

import SwiftUI
import SwiftData


struct TodoEntryView : View {
    @StateObject private var viewModel = TodoEntryViewModel()
    @Query private var todos: [Todo]
    
    init() {
        _todos = Query(viewModel.todoFetchDescrpitor(), animation: .snappy)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            ForEach(todos) { todo in
                TodoWidgetRowView(todo: todo)
            }
            Spacer()
        }
        .containerBackground(.black, for: .widget)
    }
}
