//
//  ConfigurationViewModel.swift
//  NQueens
//
//  Created by Romuald Szauer on 18/3/26.
//

import Foundation
import SwiftData

@Observable
class ConfigurationViewModel {
    private var bestTimeStore: BestTimeStore

    var boardSize: Int = 4
    
    init(
        bestTimeStore: BestTimeStore = .init()
    ) {
        self.bestTimeStore = bestTimeStore
    }
    
    enum Destination: Hashable {
        case game(boardSize: Int)
    }
    var destination: Destination?
    
    var bestTime: Duration? {
        guard let bestTime = bestTimeStore.bestTime(for: boardSize) else { return nil }
        return Duration.seconds(bestTime)
    }
    
    func startButtonTapped() {
        destination = .game(boardSize: boardSize)
    }
}
