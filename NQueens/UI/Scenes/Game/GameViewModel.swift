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
    
    init(
        boardSize: Int,
        game: any Chess.Game
    ) {
        self.board = .init(size: boardSize)
        self.game = game
    }
    
    func squareTapped(at index: Int) {
        game.squareTapped(at: index, on: &board)
    }
}
