//
//  HomeView.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 24/04/25.
//


extension Color {
    static var selectedColor = Color(.init())
}

import SwiftUI
import SwiftData
import FoundationModels

struct TodoView: View, SizedViewProtocol {
    var screenSize: CGSize
    var screenSafeAreas: EdgeInsets
    @State private var viewModel: TodoViewModel
    @State var isAddingTodo: Bool = false
    @State private var selectedColor: Color = Color(.init())
    @State private var isGenerating: Bool = true
    
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
                    .animation(isGenerating ? nil : .smooth, value: todos)
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
                    AddTodoSheetView(
                        height: screenSize.height * 0.28,
                        screenWidth: screenSize.width, screenHeight: screenSize.height,
                        createTodo: { userInputText in await viewModel.createTodo(task: userInputText) },
                        startTaskGeneration: { prompt in await viewModel.startTaskStreamGeneration(prompt: Prompt(prompt))})
                }
            }
            .glassEffectTransition(.identity, isEnabled: false)
            .navigationTitle("Todo List")
            .task { // move this
                viewModel.prewarm()
                Task {
                    try await viewModel.startTaskStreamGeneration(prompt: Prompt("I need to Learning about multithreading in Java arning and do a connection with a Kafka server"))
                }
                isGenerating = false
            }
        }
    }
    
    private func cleanForGeneratingState() {
        
    }
}

#Preview {
    TodoViewFactory.makeTodoView(
        size: DevicePreview.iPhone16Pro.size,
        safeArea: DevicePreview.iPhone16Pro.safeArea,
        context: ModelContainerProvider.shared.modelContainer.mainContext
    )
}
