//
//  View+Feedback.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

import Foundation
import SwiftUI

struct FeedbackModifier: ViewModifier {
    @Environment(\.soundEffectPlayer) var player
    let feedback: Feedback?
    
    func body(content: Content) -> some View {
        content
            .sensoryFeedback(trigger: feedback) { _, new in
                if let soundEffect = new?.sound {
                    player?.play(soundEffect)
                }
                
                return new?.sensory
            }
    }
}

extension View {
    func feedback(_ feedback: Feedback?) -> some View {
        modifier(FeedbackModifier(feedback: feedback))
    }
}
