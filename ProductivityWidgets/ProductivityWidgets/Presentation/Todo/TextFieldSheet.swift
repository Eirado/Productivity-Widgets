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
    @State private var viewModel: TodoViewModel
    private var sheetHeight: CGFloat
    
    init(height: CGFloat, viewModel: TodoViewModel) {
        self.sheetHeight = height
        self.viewModel = viewModel
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
                Button("Add Task") {
                    Task {
                        await viewModel.createTodo(task: text)
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
        .presentationDetents([.height(sheetHeight)])
        .presentationBackgroundInteraction(.enabled)
        .presentationCornerRadius(15)
    }
}
