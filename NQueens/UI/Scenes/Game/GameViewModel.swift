//
//  GameViewModel.swift
//  NQueens
//
//  Created by Romuald Szauer on 19/3/26.
//

import Foundation

@Observable
class GameViewModel {
    var board: Chess.Board
    var game: any Chess.Game
    
    var startTime: Date?
    var elapsedTime: Duration {
        guard let startTime else { return .zero }
        let elapsed = -startTime.timeIntervalSinceNow
        return Duration.seconds(elapsed)
    }
    
    init(
        boardSize: Int,
        game: any Chess.Game
    ) {
        self.board = .init(size: boardSize)
        self.game = game
    }
    
    func startGame() {
        guard startTime == nil else { return }
        startTime = Date()
    }
    
    func squareTapped(at index: Int) {
        game.squareTapped(at: index, on: &board)
    }
}
