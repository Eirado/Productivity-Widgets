//
//  CustomButtonStyle.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 01/05/25.
//

import SwiftUI

struct ModifierContainer: View {
    var body: some View {
        Color.clear
    }
}


protocol ButtonConfiguration {
    var iconName: String { get }
    var height: CGFloat { get }
    var width: CGFloat { get }
    var foregroundColor: Color { get }
    var backgroundColor: Color { get }
    var iconSize: CGFloat { get }
    
    // Animation properties
    func getAnimationEffect(isPressed: Bool) -> AnyView
}

struct AddButtonConfiguration: ButtonConfiguration {
    let height: CGFloat
    let width: CGFloat
    let foregroundColor: Color
    let backgroundColor: Color
    
    // Default values
    init(
        height: CGFloat = 56,
        width: CGFloat = .zero,
        foregroundColor: Color = .black,
        backgroundColor: Color = .white
    ) {
        self.height = height
        self.width = width
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
    
    var iconName: String {
        return "plus"
    }
    
    var iconSize: CGFloat {
        return height * 0.43
    }
    
    func getAnimationEffect(isPressed: Bool) -> AnyView {
        return AnyView(
            ModifierContainer()
                .scaleEffect(isPressed ? 0.8 : 1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isPressed)
        )
    }
}





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
