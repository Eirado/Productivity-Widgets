import Foundation
import SwiftUI
import SwiftData
import WidgetKit
import FoundationModels

enum GenerationError: Error {
    case noPrompt
}

@Observable
class TodoViewModel {
    
    public var lastAddedTodoID: PersistentIdentifier?
    
    @ObservationIgnored
    private let todoRepository: TodoRepositoryProtocol
    @ObservationIgnored
    private let languageModel: AISessionManager
    @ObservationIgnored
    private let modelContext: ModelContext
    
    // Streaming state - keep in memory only
    public var streamingTodos: [String] = []
    public var isGenerating = false
    
    // Debounce widget updates
    @ObservationIgnored
    private var widgetUpdateTask: Task<Void, Never>?
    
    init(todoRepository: TodoRepositoryProtocol, modelContext: ModelContext) {
        self.todoRepository = todoRepository
        self.modelContext = modelContext
        languageModel = AISessionManager(instructions: TaskInstruction.instruction)
    }
    
    public func createTodo(task: String) async {
        if task.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        do {
            let newTodo = try await todoRepository.createTodo(task: task)
            updateLastAddedTodoID(with: newTodo.id)
            scheduleWidgetUpdate()
        } catch {
            print("Error creating todo: \(error)")
        }
    }
    
    public func deleteTodo(todo: Todo, index: Int) async {
        do {
            _ = try await todoRepository.deleteTodo(todo: todo)
            scheduleWidgetUpdate()
        } catch {
            print("Error deleting todo: \(error)")
        }
    }
    
    public func startTaskGeneration(prompt: String) async {
        do {
            try await startTaskStreamGeneration(prompt: Prompt(prompt))
        } catch {
            print("Generation error: \(error)")
            isGenerating = false
        }
    }

    public func prewarm() {
        languageModel.prewarm()
    }
    
    public func deleteAllTodos() async {
        do {
            try await todoRepository.deleteAllTodos()
            scheduleWidgetUpdate()
        } catch {
            print("Couldn't delete all todos")
        }
    }
}

// MARK: - Private Methods
private extension TodoViewModel {
    
    func updateLastAddedTodoID(with id: PersistentIdentifier) {
        self.lastAddedTodoID = id
    }
    
    func startTaskStreamGeneration(prompt: Prompt) async throws {
        isGenerating = true
        streamingTodos.removeAll()
        
        let stream = languageModel.session.streamResponse(
            to: prompt,
            generating: GenerableTask.self,
            options: GenerationOptions(sampling: .greedy)
        )
        
        // Stream updates to UI without persisting
        for try await partialResponse in stream {
            if let todoDescriptions = partialResponse.todoDescription {
                streamingTodos = todoDescriptions
            }
        }
        
        // Only persist when generation is complete
        await persistStreamingTodos()
        isGenerating = false
    }
    
    @MainActor
    func persistStreamingTodos() async {
        guard !streamingTodos.isEmpty else { return }
        
        // Batch create all todos in a single transaction
        do {
            // Use a single ModelContext transaction for all inserts
            try modelContext.transaction {
                for todoText in streamingTodos {
                    let todo = Todo(
                        taskID: UUID().uuidString,
                        task: todoText,
                        isCompleted: false,
                        priority: .medium,
                        lastModified: Date.now
                    )
                    modelContext.insert(todo)
                    // Store the last created ID for scrolling
                    if todoText == streamingTodos.last {
                        lastAddedTodoID = todo.persistentModelID
                    }
                }
            }
            
            // Clear streaming state
            streamingTodos.removeAll()
            
            // Single widget update after all todos are saved
            WidgetCenter.shared.reloadAllTimelines()
            
        } catch {
            print("Error persisting streaming todos: \(error)")
        }
    }
    
    func scheduleWidgetUpdate() {
        // Debounce widget updates to avoid excessive reloads
        widgetUpdateTask?.cancel()
        widgetUpdateTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
            if !Task.isCancelled {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}

// MARK: - SwiftUI Integration
extension TodoViewModel {
    var displayTodos: [DisplayTodo] {
        // During generation, show streaming todos as temporary items
        if isGenerating {
            return streamingTodos.enumerated().map { index, text in
                DisplayTodo(id: "streaming-\(index)", text: text, isCompleted: false, isStreaming: true)
            }
        }
        // Otherwise show persisted todos (handled by @Query in the View)
        return []
    }
}

// MARK: - Supporting Types
struct DisplayTodo: Identifiable {
    let id: String
    let text: String
    let isCompleted: Bool
    let isStreaming: Bool
}
