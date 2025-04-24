//
//  TODOBundle.swift
//  TODO
//
//  Created by Gabriel Amaral on 24/04/25.
//

import WidgetKit
import SwiftUI

@main
struct TODOBundle: WidgetBundle {
    var body: some Widget {
        TODO()
        TODOControl()
        TODOLiveActivity()
    }
}
