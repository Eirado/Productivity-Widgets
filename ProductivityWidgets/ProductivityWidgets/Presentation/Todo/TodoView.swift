//
//  HomeView.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 24/04/25.
//


import SwiftUI
import SwiftData

struct TodoView: View, SizedViewProtocol {
    var screenSize: CGSize
    var screenSafeAreas: EdgeInsets
    @State private var viewModel: TodoViewModel
    @State var isAddingTodo: Bool = false
    
    // Refactor to only the viewModel have acess
    @Query(
        sort: [
            SortDescriptor(\Todo.isCompleted, order: .forward),
            SortDescriptor(\Todo.lastModified, order: .forward)
        ]
    ) private var todos: [Todo]
    
    init(size: CGSize, safeArea: EdgeInsets, viewModel: TodoViewModel) {
        self.screenSize = size
        self.screenSafeAreas = safeArea
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.black)
                ScrollViewReader { proxy in
                    List {
                        ForEach(todos) { todo in
                            TodoRowView(todo: todo)
                                .id(todo.id)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .animation(.smooth, value: todos)
                    .listStyle(.plain)
                    .scrollIndicators(.hidden)
                    .onChange(of: viewModel.lastAddedTodoID) { _, newId in
                        withAnimation(.smooth(duration: 0.3).delay(0.2)) {
                            proxy.scrollTo(newId, anchor: .bottom)
                        }
                    }
                }
                TodoViewButton(isAddingTodo: $isAddingTodo, screenSize: screenSize)
            }
            .sensoryFeedback(.success, trigger: todos)
            .sheet(isPresented: $isAddingTodo) {
                withAnimation(.snappy) {
                    AddTodoSheetView(height: screenSize.height * 0.28, screenWidth: screenSize.width, addTask: { text in await viewModel.createTodo(task: text) })
                }
            }
            .navigationTitle("Todo List")
        }
    }
}

#Preview {
    TodoViewFactory.makeTodoView(
        size: DevicePreview.iPhone16Pro.size,
        safeArea: DevicePreview.iPhone16Pro.safeArea,
        context: ModelContainerProvider.shared.modelContainer.mainContext
    )
}
