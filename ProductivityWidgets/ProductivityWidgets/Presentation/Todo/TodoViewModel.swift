//
//  TodoViewModel.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 25/04/25.
//

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
    public var prompt: Prompt? = nil
    
    public var generatedTask: GenerableTask.PartiallyGenerated?
    
    // Track streaming state
    @ObservationIgnored
    private var streamingTodoIDs: [PersistentIdentifier] = []
    @ObservationIgnored
    private var lastProcessedCount: Int = 0
    
    init(todoRepository: TodoRepositoryProtocol) {
        self.todoRepository = todoRepository
        languageModel = AISessionManager(instructions: TaskInstruction.instruction)
    }
    
    public func createTodo(task: String) async {
        if task.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        do {
            let newTodo = try await todoRepository.createTodo(task: task)
            updateLastAddedTodoID(with: newTodo.id)
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("Error creating todo: \(error)")
        }
    }
    
    public func deleteTodo(todo: Todo, index: Int) async {
        do {
            _ = try await todoRepository.deleteTodo(todo: todo)
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("Error deleting todo: \(error)")
        }
    }
    
    public func smoothlyScrollToNewItem(proxy: ScrollViewProxy, todoID: PersistentIdentifier, isLast: Bool) {
        if isLast {
            //
        }
        withAnimation(.smooth(duration: 0.3).delay(0.1)) {
            proxy.scrollTo(todoID, anchor: .center)
        }
    }
    
    func generateTasks(prompt: Prompt) async throws {
        self.prompt = prompt
        
        guard let prompt = self.prompt else {
            throw GenerationError.noPrompt
        }
        
        clearStreamingState()
        
        let stream = languageModel.session.streamResponse(
            to: prompt,
            generating: GenerableTask.self,
            options: GenerationOptions(sampling: .greedy)
        )
        
        for try await partialResponse in stream {
            generatedTask = partialResponse
            await processStreamingUpdate(partialResponse)
            print(generatedTask)
        }

        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func processStreamingUpdate(_ partialResponse: GenerableTask.PartiallyGenerated) async {
        guard let todoDescriptions = partialResponse.todoDescription else { return }
        
        let currentCount = todoDescriptions.count
        
        // Handle new todos (when array grows)
        if currentCount > lastProcessedCount {
            // Create new todos for new indices
            for index in lastProcessedCount..<currentCount {
                let todoText = todoDescriptions[index]
                do {
                    let newTodo = try await todoRepository.createTodo(task: todoText)
                    streamingTodoIDs.append(newTodo.id)
                } catch {
                    print("Error creating streaming todo: \(error)")
                }
            }
        }
        
        // Update existing todos with new content (only task property changes)
        for (index, todoDescription) in todoDescriptions.enumerated() {
            if index < streamingTodoIDs.count {
                let todoID = streamingTodoIDs[index]
                await updateStreamingTodoTask(todoID: todoID, newTask: todoDescription)
            }
        }
        
        lastProcessedCount = currentCount
    }
    
    private func updateStreamingTodoTask(todoID: PersistentIdentifier, newTask: String) async {
        do {
            try await todoRepository.updateTask(todoID: todoID, newTask: newTask, isGenerating: true)
        } catch {
            print("Error updating streaming todo task: \(error)")
        }
    }
    
    public func prewarm() {
        languageModel.prewarm()
    }
    
    public func deleteAllTodo() async {
        do {
            try await self.todoRepository.deleteAllTodos()
        } catch {
            print("couldn't delete")
        }
    }

    public func clearStreamingState() {
        streamingTodoIDs.removeAll()
        lastProcessedCount = 0
        generatedTask = nil
    }
}

private extension TodoViewModel {
    func updateLastAddedTodoID(with id: PersistentIdentifier) {
        self.lastAddedTodoID = id
    }
}
