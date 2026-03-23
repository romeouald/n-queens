//
//  EnvironmentValues+SoundEffectPlayer.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

import SwiftUI

struct SoundEffectPlayerKey: EnvironmentKey {
    static let defaultValue: (any SoundEffectPlaying)? = nil
}

extension EnvironmentValues {
    var soundEffectPlayer: (any SoundEffectPlaying)? {
        get { self[SoundEffectPlayerKey.self] }
        set { self[SoundEffectPlayerKey.self] = newValue }
    }
}
