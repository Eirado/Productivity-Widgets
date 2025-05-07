//
//  CustomButtonStyle.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 01/05/25.
//

import SwiftUI

enum ButtonRank {
    case primary
    case sendLoading
}

struct ButtonStyleConfig {
    var backgroundColor: Color
    var foregroundColor: Color
    var cornerRadius: CGFloat
    var pressedScale: CGFloat
    var pressedOpacity: Double
    var font: Font?
    var borderColor: Color?
    var borderWidth: CGFloat
    var isCircular: Bool
    
    static func config(for rank: ButtonRank) -> ButtonStyleConfig {
        switch rank {
        case .primary:
            return ButtonStyleConfig(
                backgroundColor: .white,
                foregroundColor: .black,
                cornerRadius: 0,
                pressedScale: 0.8,
                pressedOpacity: 1,
                font: .headline,
                borderColor: nil,
                borderWidth: 0,
                isCircular: true
            )
        case .sendLoading:
            return ButtonStyleConfig(
                backgroundColor: .white,
                foregroundColor: .black,
                cornerRadius: 0,
                pressedScale: 0.8,
                pressedOpacity: 1,
                font: .headline,
                borderColor: nil,
                borderWidth: 0,
                isCircular: true
            )
            
        
        }
    }
}


private extension CustomButtonStyle {
    @ViewBuilder
    static func StandardButtonView(
        configuration: ButtonStyleConfiguration,
        config: ButtonStyleConfig,
        width: CGFloat?,
        height: CGFloat
    ) -> some View {
        configuration.label
            .font(config.font)
            .foregroundColor(config.foregroundColor)
            .frame(width: width, height: height)
            .background(
                Group {
                    if let borderColor = config.borderColor, config.borderWidth > 0 {
                        RoundedRectangle(cornerRadius: config.cornerRadius)
                            .stroke(borderColor, lineWidth: config.borderWidth)
                            .background(
                                RoundedRectangle(cornerRadius: config.cornerRadius)
                                    .fill(config.backgroundColor)
                            )
                    } else {
                        RoundedRectangle(cornerRadius: config.cornerRadius)
                            .fill(config.backgroundColor)
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? config.pressedScale : 1.0)
            .opacity(configuration.isPressed ? config.pressedOpacity : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

private extension CustomButtonStyle {
    @ViewBuilder
    static func addButtonDumping(
        configuration: ButtonStyleConfiguration,
        config: ButtonStyleConfig,
        width: CGFloat
    ) -> some View {
        configuration.label
        ZStack {
            Circle()
                .fill(config.backgroundColor)
                .frame(width: width, height: width)
            Image(systemName: "plus")
                .font(.system(size: width * 0.43, weight: .bold))
                .foregroundColor(config.foregroundColor)
        }
        .scaleEffect(configuration.isPressed ? config.pressedScale : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

private extension CustomButtonStyle {
    @ViewBuilder
    static func sendButtonDumping(
        configuration: ButtonStyleConfiguration,
        config: ButtonStyleConfig,
        width: CGFloat
    ) -> some View {
        configuration.label
        ZStack {
            Circle()
                .fill(config.backgroundColor)
                .frame(width: width, height: width)
            if configuration.isPressed {
                ProgressView()
                    .tint(config.foregroundColor)
            } else {
                Image(systemName: "arrow.up")
                    .font(.system(size: width * 0.43, weight: .bold))
                    .foregroundColor(config.foregroundColor)
            }
        }
        .scaleEffect(configuration.isPressed ? config.pressedScale : 1.0)
    }
}


extension ButtonStyle where Self == CustomButtonStyle {
    static func customStyle(
        rank: ButtonRank = .primary,
        width: CGFloat = .zero,
        height: CGFloat = .zero,
        screenSafeAreas: EdgeInsets = .init(.zero)
    ) -> Self {
        CustomButtonStyle(rank: rank, width: width, height: height, screenSafeAreas: screenSafeAreas)
    }
}

struct CustomButtonStyle: ButtonStyle {
    let rank: ButtonRank
        let height: CGFloat
        let width: CGFloat
        let screenSafeAreas: EdgeInsets
        private let config: ButtonStyleConfig
        
        init(rank: ButtonRank, width: CGFloat, height: CGFloat, screenSafeAreas: EdgeInsets) {
            self.rank = rank
            self.width = width
            self.height = height
            self.screenSafeAreas = screenSafeAreas
            self.config = ButtonStyleConfig.config(for: rank)
        }
    
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        switch rank {
        case .primary:
            CustomButtonStyle.addButtonDumping(configuration: configuration, config: config, width: width)
        case .sendLoading:
            CustomButtonStyle.sendButtonDumping(configuration: configuration, config: config, width: width)
        }
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
                        .buttonStyle(.customStyle(rank: .primary, width: geometry.size.width * 0.4))

                    }.frame(width: geometry.size.width, height: geometry.size.height )

                }
            }
        }
    }
}

#Preview {
    buttonPreview()
}
