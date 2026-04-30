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
    
    enum Game: CaseIterable, Hashable, Identifiable {
        var id: Self { self }
        case nqueens
        case nknights
    }
    var game: Game = .nknights
    
    init(
        bestTimeStore: any BestTimeStoring = BestTimeStore(context: .live)
    ) {
        self.bestTimeStore = bestTimeStore
    }
    
    enum Destination: Hashable {
        case game(boardSize: Int, game: Game)
    }
    var destination: Destination?
    
    var bestTime: Duration? {
        guard let bestTime = bestTimeStore.bestTime(for: boardSize) else { return nil }
        return Duration.seconds(bestTime)
    }
    
    func startButtonTapped() {
        destination = .game(boardSize: boardSize, game: game)
    }
}

extension ConfigurationViewModel.Game {
    var engine: Chess.Game.Engine {
        switch self {
        case .nqueens: NQueens()
        case .nknights: NKnights()
        }
    }
}
