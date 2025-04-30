//
//  DevicePreview.swift
//  WallpaperApp
//
//  Created by Gabriel Amaral on 14/04/25.
//

import SwiftUI

struct DevicePreview {
    static let iPhone16Pro = DevicePreviewData(
        size: CGSize(width: 393, height: 852),
        safeArea: EdgeInsets(top: 59, leading: 0, bottom: 34, trailing: 0) // Dynamic Island + Home Indicator
    )
}
