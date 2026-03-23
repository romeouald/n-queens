//
//  Feedback.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

import Foundation
import SwiftUI
import os

struct Feedback: Equatable {
    private static let lock = OSAllocatedUnfairLock(initialState: 0)
    
    private let counter: Int
    let sound: SoundEffect?
    let sensory: SensoryFeedback?
    
    init(
        sound: SoundEffect? = nil,
        sensory: SensoryFeedback? = nil
    ) {
        // A private always incrementing counter.
        // This ensures that the feedback always triggers
        // even if it's the same as the previous one.
        self.counter = Self.lock.withLock { state in
            state += 1
            return state
        }
        self.sound = sound
        self.sensory = sensory
    }
}
