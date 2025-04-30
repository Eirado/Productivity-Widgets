//
//  HomeView.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 24/04/25.
//
import SwiftUI
import SwiftData

struct TodoView: View, SizedViewProtocol {
    var size: CGSize
    var safeArea: EdgeInsets
    
    @State private var viewModel: TodoViewModel
    
    @State private var focusedTodoID: UUID? = nil
    @FocusState private var focusedField: UUID?
    
    @Query(
        sort: [
            SortDescriptor(\Todo.isCompleted, order: .forward),
            SortDescriptor(\Todo.lastModified, order: .forward)
        ]
    ) private var todos: [Todo]
    
    init(size: CGSize, safeArea: EdgeInsets, viewModel: TodoViewModel) {
        self.size = size
        self.safeArea = safeArea
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(todos) { todo in
                    TodoRowView(todo: todo)
                }
            }
            .animation(.snappy, value: todos)
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        Task {
                            await viewModel.createTodo(task: "")
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .fontWeight(.light)
                            .font(.system(size: 42))
                    }
                }
            }
        }
    }
}

#Preview {
    TodoViewFactory.makeTodoView(
        size: DevicePreview.iPhone16Pro.size,
        safeArea: DevicePreview.iPhone16Pro.safeArea,
        context: ModelContainerProvider().context
    )
}
