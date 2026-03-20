//
//  BoardViewModel.swift
//  NQueens
//
//  Created by Romuald Szauer on 19/3/26.
//

import SwiftUI

@Observable
class BoardViewModel {
    var board: Chess.Board
    var game: any Chess.Game
    
    init(board: Chess.Board, game: any Chess.Game) {
        self.board = board
        self.game = game
    }
    
    func squareTapped(at index: Int) {
        game.squareTapped(at: index, on: &board)
    }
}
