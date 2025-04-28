//
//  ContentView.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 24/04/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var context

    var body: some View {
        GeometryReader { geometry in
            TodoViewFactory.makeTodoView(size: geometry.size, safeArea: geometry.safeAreaInsets, context: context)
        }
    }
}
