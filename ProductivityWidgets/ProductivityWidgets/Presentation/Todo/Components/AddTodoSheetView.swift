//
//  TextFieldSheet.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 30/04/25.
//

import SwiftUI
//
//  TextFieldSheet.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 30/04/25.
//

import SwiftUI

struct AddTodoSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""
    private let createTodo: (String) async -> Void
    private let screenWidth: CGFloat
    private let screenHeight: CGFloat
    private let initialHeight: CGFloat
    private let lineHeight: CGFloat = 24
    
    init(height: CGFloat, screenWidth: CGFloat, screenHeight: CGFloat, addTask: @escaping (String) async -> Void) {
        self.initialHeight = height
        self.createTodo = addTask
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
    }
    
    private var currentSheetHeight: CGFloat {
        let lineCount = text.filter { $0.isNewline }.count + 1
        if lineCount > 2 {
            let additionalHeight = CGFloat(lineCount - 2) * lineHeight
            let calculatedHeight = initialHeight + additionalHeight
            return min(calculatedHeight, screenHeight * 0.9)
        }
        return initialHeight
    }

    
    var body: some View {
        VStack {
            VStack{
                TextField("Enter task...", text: $text, axis: .vertical)
                    .padding(.horizontal)
                    .padding(.vertical)
                    .frame(minHeight: currentSheetHeight * 0.4)
                    .background(Color(.systemGray6))
                    .multilineTextAlignment(.leading)
                    .focusOnAppear()
                    .onSubmit {
                        dismiss()
                    }
            }
            Spacer()
            HStack {
                Spacer()
                Button {
                    Task {
                        await createTodo(text)
                    }
                    dismiss()
                } label: {  }
                    .buttonStyle(.customStyle(rank: .sendLoading, width: screenWidth * 0.12))
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
        .presentationDetents([.height(currentSheetHeight)])
        .presentationBackgroundInteraction(.enabled)
        .presentationCornerRadius(15)
    }
}
