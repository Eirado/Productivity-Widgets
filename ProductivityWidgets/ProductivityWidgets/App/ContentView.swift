//
//  ContentView.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 24/04/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            TodoView(
                size: geometry.size,
                safeArea: geometry.safeAreaInsets
            )
        }
    }
}

#Preview {
    ContentView()
}
