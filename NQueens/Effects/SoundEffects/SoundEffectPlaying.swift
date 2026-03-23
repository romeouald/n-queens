//
//  SoundEffectPlayer.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

import AVKit
import Foundation

protocol SoundEffectPlaying {
    func preload(_ effects: [SoundEffect])
    func play(_ effect: SoundEffect)
}
