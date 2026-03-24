//
//  Feedback.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

import Foundation
import SwiftUI

struct Feedback: Equatable {
    // Each instance is uniquely identified, ensuring that even identical
    // feedbacks are never equal — making this safe to use as a trigger.
    private let uuid = UUID()
    let sound: SoundEffect?
    let sensory: SensoryFeedback?
    
    init(
        sound: SoundEffect? = nil,
        sensory: SensoryFeedback? = nil
    ) {
        self.sound = sound
        self.sensory = sensory
    }
}
