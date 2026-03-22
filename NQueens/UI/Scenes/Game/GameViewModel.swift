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
    
    typealias Progress = Chess.GameResult.Progress
    var progress: Progress
    
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
        self.progress = .init(step: 0, total: boardSize)
    }
    
    func startGame() {
        guard startTime == nil else { return }
        startTime = Date()
    }
    
    func squareTapped(at index: Int) {
        guard !gameFinished else { return }
        
        let result = game.squareTapped(at: index, on: &board)
        switch result {
        case .ongoing(let progress):
            self.progress = progress
        case .finished:
            finishTime = Date()
            progress = .init(step: board.size, total: board.size)
            
            if bestTime == nil || elapsedTime < bestTime! {
                bestTimeStore.saveBestTime(boardSize: board.size, time: elapsedTime.timeInterval)
            }
        }
    }
}

extension GameViewModel {
    static var preview: GameViewModel {
        .init(
            bestTimeStore: BestTimeStore(context: .preview),
            boardSize: 4,
            game: NQueens()
        )
    }
}
