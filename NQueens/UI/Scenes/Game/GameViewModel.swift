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

    private(set) var board: Chess.Board
    private var game: any Chess.Game.Interface
    
    private(set) var bestTime: Duration?
    private(set) var startTime: Date?
    private(set) var finishTime: Date?
    var elapsedTime: Duration {
        guard let startTime else { return .zero }
        
        let endTime = finishTime ?? Date()
        let elapsed = endTime.timeIntervalSince(startTime)
        return Duration.seconds(elapsed)
    }

    typealias Progress = Chess.Game.Progress
    private(set) var progress: Progress
    private var gameStatus: Chess.Game.Status
    var hasError: Bool { gameStatus == .conflicting }
    var gameFinished: Bool { gameStatus == .solved }
    
    init(
        bestTimeStore: BestTimeStore = .init(),
        boardSize: Int,
        game: any Chess.Game.Interface
    ) {
        self.bestTimeStore = bestTimeStore
        self.board = .init(size: boardSize)
        self.game = game
        
        if let bestTime = bestTimeStore.bestTime(for: boardSize) {
            self.bestTime = Duration.seconds(bestTime)
        }
        self.progress = .init(step: 0, total: boardSize)
        self.gameStatus = .normal
    }
    
    func startGame() {
        guard startTime == nil else { return }
        startTime = Date()
    }
    
    func squareTapped(at index: Int) {
        guard !gameFinished else { return }
        
        let result = game.squareTapped(at: index, on: &board)
        gameStatus = result.gameStatus
        progress = result.progress

        if gameFinished {
            finishTime = Date()

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
