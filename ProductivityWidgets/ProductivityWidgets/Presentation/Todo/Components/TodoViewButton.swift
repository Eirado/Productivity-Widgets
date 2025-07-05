//
//  TodoViewButton.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 01/05/25.
//

import SwiftUI

struct TodoViewButton: View {
    @Binding var isAddingTodo: Bool
    var screenSize: CGSize
    @State private var trigger = false
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    isAddingTodo = true
                    trigger.toggle()
                } label: {
                  
                }
                .sensoryFeedback(.impact(flexibility: .solid), trigger: trigger)
                .buttonStyle(.customStyle(rank: .primary, width: screenSize.width * 0.18))
                .padding(.vertical)
                .padding(.horizontal, 20)
            }
        }
    }
}
