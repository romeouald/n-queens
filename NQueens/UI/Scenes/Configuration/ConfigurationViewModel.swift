//
//  ConfigurationViewModel.swift
//  NQueens
//
//  Created by Romuald Szauer on 18/3/26.
//

import Foundation

@Observable
final class ConfigurationViewModel {
    private var bestTimeStore: any BestTimeStoring

    var boardSize: Int = 8
    
    init(
        bestTimeStore: any BestTimeStoring = BestTimeStore(context: .live)
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
