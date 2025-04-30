//
//  SizedViewProtocol.swift
//  WallpaperApp
//
//  Created by Gabriel Amaral on 14/04/25.
//

import SwiftUI

protocol SizedViewProtocol {
    var size: CGSize { get }
    var safeArea: EdgeInsets { get }
}
