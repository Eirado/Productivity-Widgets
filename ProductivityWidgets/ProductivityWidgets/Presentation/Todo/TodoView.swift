import Foundation
import SwiftUI
import SwiftData
import WidgetKit
import FoundationModels


// MARK: - Updated TodoView that preserves existing functionality
struct TodoView: View, SizedViewProtocol {
    var screenSize: CGSize
    var screenSafeAreas: EdgeInsets
    @State private var viewModel: TodoViewModel
    @State var isAddingTodo: Bool = false
    @State private var selectedColor: Color = Color(.init())
    @State private var isGenerating: Bool = false
    
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
                        // Show persisted todos
                        ForEach(todos) { todo in
                            TodoRowView(todo: todo)
                                .id(todo.id)
                                .listRowSeparator(.hidden)
                        }
                        
                        // Show streaming todos during generation
                        if viewModel.isGenerating {
                                                   ForEach(Array(viewModel.streamingTodos.enumerated()), id: \.offset) { index, text in
                                                       StreamingTodoRowView(
                                                           text: text,
                                                           index: index
                                                       )
                                                       .id("streaming-\(index)")
                                                       .listRowSeparator(.hidden)
                                                   }
                        }
                    }
                    .animation(isGenerating ? nil : .smooth, value: todos)
                    .listStyle(.plain)
                    .scrollIndicators(.hidden)
                    .onChange(of: viewModel.lastAddedTodoID) { _, newId in
                        guard let newId = newId else { return }
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
                        screenWidth: screenSize.width,
                        screenHeight: screenSize.height,
                        createTodo: { userInputText in await
                            viewModel.createTodo(task: userInputText)
                        },
                        startTaskGeneration: { prompt in
                            isGenerating = true
                            await viewModel.startTaskGeneration(prompt: prompt)
                            isGenerating = false
                        },
                        prewarm: { viewModel.prewarm() }
                    )
                }
            }
            .glassEffect(isEnabled: false)
            .glassEffectTransition(.identity, isEnabled: false)
            .navigationTitle("Todo List")
        }
    }
    
    private func cleanForGeneratingState() {
        // Kept for compatibility
    }
}

import SwiftUI

struct StreamingTodoRowView: View {
    let text: String
    let index: Int
    
    @State private var animate = false
    
    // The exact gradient colors from your example
    let gradientColors: [Color] = [
        .yellow.opacity(0.1), .mint.opacity(0.2), .yellow.opacity(0.1),
        .purple, .orange, .pink, .purple, .cyan, .purple, .pink, .orange,
        .mint.opacity(0.1), .mint.opacity(0.2), .yellow.opacity(0.1)
    ]
    
    var body: some View {
        HStack {
            Image(systemName: "circle")
                .foregroundColor(.gray.opacity(0.6))
            
            // We start with your original Text view to preserve its layout perfectly.
            Text(text)
                .opacity(0.8)
                // We make the text itself clear...
                .foregroundColor(.clear)
                // ...and paint the animated gradient in the background.
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: UIScreen.main.bounds.width * 8.9, height: 800)
                    .offset(x: animate ? UIScreen.main.bounds.width * -3.4 : UIScreen.main.bounds.width * 4)
                    .rotationEffect(.degrees(20)).rotationEffect(.degrees(180))
                )
                // The mask clips the background gradient to the shape of the text.
                .mask(
                    Text(text)
                        .opacity(0.8)
                )
                // Your original overlay for the "typing" indicator is untouched.
                .overlay(
                    HStack {
                        Spacer()
                        if text.isEmpty {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                    }
                )
                .animation(.linear(duration: 10).repeatForever(autoreverses: false), value: animate)
                .onAppear {
                    animate = true
                }
        }
        .listRowBackground(Color.clear)
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }
}
