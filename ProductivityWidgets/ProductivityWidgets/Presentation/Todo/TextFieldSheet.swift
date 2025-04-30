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
    @FocusState private var isTextFieldFocused: Bool
    private var height: CGFloat
    
    init(height: CGFloat) {
        self.height = height
    }
    
    var body: some View {
        VStack {
            TextField("Enter task...", text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onSubmit {
                    dismiss()
                }
                .focusOnAppear()
            HStack {
                Spacer()
                Button("Add Task") {
                    
                }
                .buttonStyle(.borderedProminent)
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
        .presentationDetents([.height(height)])
        .presentationBackgroundInteraction(.enabled)
        .presentationCornerRadius(15)

    }
}
