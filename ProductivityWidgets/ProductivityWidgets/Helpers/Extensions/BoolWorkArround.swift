//
//  BoolWorkArround.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 29/04/25.
//


extension Bool: @retroactive Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        !lhs && rhs
    }
}
