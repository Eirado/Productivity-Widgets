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
    private var sheetHeight: CGFloat
    private let screenWidth: CGFloat
    
    init(height: CGFloat, screenWidth: CGFloat, addTask: @escaping (String) async -> Void) {
        self.sheetHeight = height
        self.createTodo = addTask
        self.screenWidth = screenWidth
    }
    
    var body: some View {
        VStack {
            VStack{
                TextField("Enter task...", text: $text, axis: .vertical)
                    .padding(.horizontal)
                    .padding(.vertical)
                    .frame(minHeight: sheetHeight * 0.5)
                    .background(Color(.systemGray6))
                    .multilineTextAlignment(.leading)
                    .onSubmit {
                        dismiss()
                    }
                    .focusOnAppear()
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
        .presentationDetents([.height(sheetHeight)])
        .presentationBackgroundInteraction(.enabled)
        .presentationCornerRadius(15)
    }
}
