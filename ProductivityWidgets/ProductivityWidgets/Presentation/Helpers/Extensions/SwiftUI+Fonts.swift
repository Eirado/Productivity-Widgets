//
//  SwiftUI+Fonts.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 06/05/25.
//

import SwiftUI

extension Font {
    static func inter(fontweight: Weight = .regular, fontStyle: Font.TextStyle = .body) -> Font {
        return Font.custom(CustomFont(weight: fontweight).rawValue, size: fontStyle.size)
    }
    
    static func interItalic(fontweight: Weight = .regular, fontStyle: Font.TextStyle = .body) -> Font {
        return Font.custom(CustomFontItalic(weight: fontweight).rawValue, size: fontStyle.size)
    }
}



enum CustomFont: String {
    case thin = "Inter-Thin"
    case extraLight = "Inter-ExtraLight"
    case light = "Inter-Light"
    case regular = "Inter-Regular"
    case medium = "Inter-Medium"
    case semiBold = "Inter-SemiBold"
    case bold = "Inter-Bold"
    case extraBold = "Inter-ExtraBold"
    case black = "Inter-Black"
    
    init(weight: Font.Weight) {
        switch weight {
        case .ultraLight:
            self = .thin
        case .thin:
            self = .extraLight
        case .light:
            self = .light
        case .regular:
            self = .regular
        case .medium:
            self = .medium
        case .semibold:
            self = .semiBold
        case .bold:
            self = .bold
        case .heavy:
            self = .extraBold
        case .black:
            self = .black
        default:
            self = .regular
        }
    }
}

enum CustomFontItalic: String {
    case thinItalic = "Inter-ThinItalic"
    case extraLightItalic = "Inter-ExtraLightItalic"
    case lightItalic = "Inter-LightItalic"
    case italic = "Inter-Italic"
    case mediumItalic = "Inter-MediumItalic"
    case semiBoldItalic = "Inter-SemiBoldItalic"
    case boldItalic = "Inter-BoldItalic"
    case extraBoldItalic = "Inter-ExtraBoldItalic"
    case blackItalic = "Inter-BlackItalic"
    
    init(weight: Font.Weight) {
        switch weight {
        case .ultraLight:
            self = .thinItalic
        case .thin:
            self = .extraLightItalic
        case .light:
            self = .lightItalic
        case .regular:
            self = .italic
        case .medium:
            self = .mediumItalic
        case .semibold:
            self = .semiBoldItalic
        case .bold:
            self = .boldItalic
        case .heavy:
            self = .extraBoldItalic
        case .black:
            self = .blackItalic
        default:
            self = .italic
        }
    }
}

extension Font.TextStyle {
    /// Returns the default point size for each text style.
    var size: CGFloat {
        switch self {
        case .largeTitle:
            return 34
        case .title:
            return 30
        case .title2:
            return 22
        case .title3:
            return 20
        case .headline:
            return 18
        case .body:
            return 16
        case .callout:
            return 15
        case .subheadline:
            return 14
        case .footnote:
            return 13
        case .caption:
            return 12
        case .caption2:
            return 11
        @unknown default:
            return 8
        }
    }
}
