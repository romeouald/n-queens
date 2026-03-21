//
//  GameViewModel.swift
//  NQueens
//
//  Created by Romuald Szauer on 19/3/26.
//

import Foundation

@Observable
class GameViewModel {
    private var bestTimeStore: BestTimeStore

    var board: Chess.Board
    var game: any Chess.Game
    
    var bestTime: Duration?
    var startTime: Date?
    var finishTime: Date?
    var elapsedTime: Duration {
        guard let startTime else { return .zero }
        
        let endTime = finishTime ?? Date()
        let elapsed = endTime.timeIntervalSince(startTime)
        return Duration.seconds(elapsed)
    }
    
    var gameFinished: Bool { finishTime != nil }
    
    init(
        bestTimeStore: BestTimeStore = .init(),
        boardSize: Int,
        game: any Chess.Game
    ) {
        self.bestTimeStore = bestTimeStore
        self.board = .init(size: boardSize)
        self.game = game
        
        if let bestTime = bestTimeStore.bestTime(for: boardSize) {
            self.bestTime = Duration.seconds(bestTime)
        }
    }
    
    func startGame() {
        guard startTime == nil else { return }
        startTime = Date()
    }
    
    func squareTapped(at index: Int) {
        guard !gameFinished else { return }
        
        let result = game.squareTapped(at: index, on: &board)
        switch result {
        case .ongoing:
            break
        case .finished:
            finishTime = Date()
            
            if bestTime == nil || elapsedTime < bestTime! {
                bestTimeStore.saveBestTime(boardSize: board.size, time: elapsedTime.timeInterval)
            }
        }
    }
}
