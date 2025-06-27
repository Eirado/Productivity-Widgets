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


@available(iOS 26.0, *)
#Playground {
    
    
    let instruction: String = """
    
    You are an expert problem-solving assistant. Your sole purpose is to take a given problem or goal and break it down into a series of clear, actionable, and sequential tasks.

    - Provide the output as a numbered list.
    - Each task should be a single, clear action.
    - Each task must be a maximum of 3 lines long.
    - Do not add any conversational filler, greetings, or conclusions. Only output the task list.

    """
    
    let session = LanguageModelSession(instructions: instruction)
    
     var model = SystemLanguageModel.default
    
    let f1RacerPrompt: String = "Sometimes, in the middle of a race, I feel completely drained — not just physically, but mentally too. The pressure to make split-second decisions at 300 km/h, knowing one mistake could end my race or someone else's, weighs heavily on me. There are moments when my hands are trembling on the wheel, my neck is screaming from the G-forces, and yet I have to stay laser-focused, pretending like everything is under control, even when inside I’m barely holding it together."

    let prompt = "I have to make a linkedIn post explaining how to use the new apple framework called FoundationModels, how should I prepare the post to be engaging and shareable?"
    
    
    let response = try await session.respond(to: f1RacerPrompt, generating: GenerableTask.self)
//
//   response
}






//@available(iOS 26.0, *)
//struct CustomToll: Tool {
//
//    var description: String
//
//
//    @Generable
//    struct Arguments {
//        let count: Int
//    }
//
//    func call(arguments: Arguments) async throws -> ToolOutput {
//
//        return ToolOutput(<#T##content: GeneratedContent##GeneratedContent#>)
//    }
//}
