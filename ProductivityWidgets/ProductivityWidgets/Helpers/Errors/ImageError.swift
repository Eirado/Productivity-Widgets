//
//  ImageError.swift
//  WallpaperApp
//
//  Created by Gabriel Amaral on 14/04/25.
//

import Foundation

enum ImageError: Error, LocalizedError {
    
    case noItemSelected
    case dataConversionFailed
    case imageCreationFailed

    var errorDescription: String? {
        switch self {
        case .noItemSelected:
            return "No image item was selected."
        case .dataConversionFailed:
            return "Failed to convert the selected item to data."
        case .imageCreationFailed:
            return "Failed to create an image from the data."
        }
    }
}
