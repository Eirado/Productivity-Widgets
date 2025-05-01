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
    @State var isAddingTodo: Bool = false
    
    // Refactor to only the viewModel have acess
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
            ZStack {
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
                       
                        withAnimation(.smooth(duration: 0.3).delay(0.1)) {
                            proxy.scrollTo(newId, anchor: .bottom)
                            }
                        
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            isAddingTodo = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .fontWeight(.light)
                                .font(.system(size: 42))
                        }
                    }
                    .padding(.horizontal)
                }
                
            }
            .sheet(isPresented: $isAddingTodo) {
                withAnimation(.snappy) {
                    AddTodoSheetView(height: size.height * 0.28, viewModel: viewModel)
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
        context: ModelContainerProvider().context
    )
}
