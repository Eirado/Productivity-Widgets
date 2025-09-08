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
        }.task {
            viewModel.prewarm()
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
    
    let electricBlue = Color(red: 0.2, green: 0.8, blue: 1.0)
    let vividViolet = Color(red: 0.65, green: 0.4, blue: 1.0)
    let luminousMagenta = Color(red: 1.0, green: 0.3, blue: 0.8)
    let goldenOrange = Color(red: 1.0, green: 0.7, blue: 0.2)

    var gradientColors: [Color] {
        [
            electricBlue.opacity(0.6),
            vividViolet,
            luminousMagenta,
            goldenOrange,
            luminousMagenta,
            vividViolet,
            electricBlue.opacity(0.6)
        ]
    }
    
    var body: some View {
        // Match the spacing and alignment from TodoRowView
        HStack(spacing: 8) { // <-- Added spacing
            Image(systemName: "circle")
                .font(.title2)
                .padding(3) // <-- Added padding
                .foregroundColor(.gray.opacity(0.6))
         
            Text(text)
                .font(.interItalic(fontweight: .regular, fontStyle: .body))
                .opacity(0.8)
                .foregroundColor(.clear)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: UIScreen.main.bounds.width * 8.9, height: 800)
                    .blur(radius: 10)
                    .offset(x: animate ? UIScreen.main.bounds.width * -3.4 : UIScreen.main.bounds.width * 4)
                    .rotationEffect(.degrees(20)).rotationEffect(.degrees(180))
                )
                .mask(
                    Text(text)
                        .font(.interItalic(fontweight: .regular, fontStyle: .body))
                        .opacity(0.8)
                )
                .animation(.linear(duration: 3.5).repeatForever(autoreverses: true), value: animate)
                .onAppear {
                    animate = true
                }
        }
        .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
        .listRowBackground(Color.clear)
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }
}
