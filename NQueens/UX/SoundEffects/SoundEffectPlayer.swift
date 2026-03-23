//
//  AudioPlaying.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

import AVKit
import Foundation
import os

private extension Logger {
    static let audioPlayer = Logger(subsystem: "AudioPlayer", category: "Resource")
}
final class SoundEffectPlayer: SoundEffectPlaying {

    private var players: [SoundEffect: AVAudioPlayer] = [:]
    
    init(preload: Bool = false) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
        } catch {
            Logger.audioPlayer.error("Failed to set AVAudioSession category")
        }
        
        if preload { self.preload(SoundEffect.allCases) }
    }
    
    @discardableResult
    private func player(for effect: SoundEffect) -> AVAudioPlayer? {
        if let player = players[effect] {
            return player
        }

        guard let audioData = NSDataAsset(name: effect.rawValue) else {
            Logger.audioPlayer.error("Audio data not found for effect: \(effect.rawValue)")
            return nil
        }
        
        do {
            let player = try AVAudioPlayer(data: audioData.data)
            player.prepareToPlay()
            players[effect] = player
            return player
        } catch {
            Logger.audioPlayer.error("Could not create audio player for effect: \(effect.rawValue). Underlying error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func preload(_ effects: [SoundEffect]) {
        effects.forEach { player(for: $0) }
    }
    
    func play(_ effect: SoundEffect) {
        player(for: effect)?.play()
    }
    
}
