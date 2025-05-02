//
//  CustomButtonStyle.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 01/05/25.
//

import SwiftUI

enum ButtonRank {
    case primary
}

extension ButtonStyle where Self == CustomButtonStyle {
    static func customStyle(
        rank: ButtonRank = .primary,
        width: CGFloat = .zero,
        height: CGFloat = .zero,
        screenSafaAreas: EdgeInsets = .init(.zero)
    ) -> CustomButtonStyle {
        
        CustomButtonStyle(rank: rank, width: width, height: height, screenSafaAreas: screenSafaAreas)
    }
}

struct CustomButtonStyle: ButtonStyle {
    let rank: ButtonRank
    let height: CGFloat
    let width: CGFloat
    let screenSafaAreas: EdgeInsets
    
    init(rank: ButtonRank, width: CGFloat, height: CGFloat, screenSafaAreas: EdgeInsets) {
        self.rank = rank
        self.width = width
        self.height = height
        self.screenSafaAreas = screenSafaAreas
    }
    
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration.label
        ZStack {
            Circle()
                .fill(.white)
                .frame(height: height)
            Image(systemName: "plus")
                .font(.system(size: height * 0.43, weight: .bold))
                .foregroundColor(.black)
        }
        .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct buttonPreview: View {
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    Color.gray
                        .ignoresSafeArea()
                    VStack(alignment: .center, spacing: 10) {
                        Button("") {
                            
                        }
                        .buttonStyle(.customStyle(width: geometry.size.width ,height: geometry.size.width * 0.2))
                        
                    }.frame(width: geometry.size.width, height: geometry.size.height )
                    
                }
            }
        }
    }
}

#Preview {
    buttonPreview()
}
