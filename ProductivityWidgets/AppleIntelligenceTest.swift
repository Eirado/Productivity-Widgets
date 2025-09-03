//
//  AppleIntelligenceTest.swift
//  ProductivityWidgets
//
//  Created by Gabriel Amaral on 23/06/25.
//


import Playgrounds
import FoundationModels
import Foundation
import SwiftUI

@available(iOS 26.0, *)

@Generable
struct GenerableTask {
    @Guide(description: "A TODO that can be maked as completed")
    let todoDescription: [String]
}

@Generable
struct FinancialPlan {
    @Guide(description: "A list of budgeting recommendations", .count(3))
    var recommendations: [BudgetTip]
    
    @Guide(description: "Estimated monthly savings potential in dollars")
    var estimatedSavings: Int
}

@Generable
struct BudgetTip {
    
    @Guide(description: "A practical money-saving tip in 10 words or less")
    var tip: String
    
    @Guide(description: "Easy, Medium, or Hard difficulty to implement")
    var difficulty: String
}


@available(iOS 26.0, *)
#Playground {
    
    let session = LanguageModelSession(instructions: """
    You are a personal finance wellness coach focused on practical, achievable advice.
    """)

    let response = try await session.respond(
        to: "Help me create a budget plan for someone earning $3000/month",
        generating: FinancialPlan.self
    )
    
    print(response.content.estimatedSavings)
    
    // response is now a FinancialPlan object with guaranteed structure
    print(response.content.estimatedSavings)  // Actual Int, not a string to parse
    response.content.recommendations.forEach { tip in
        print("💡 \(tip.tip) - Difficulty: \(tip.difficulty)")
    }
    
}




