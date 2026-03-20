//
//  GameViewModel.swift
//  NQueens
//
//  Created by Romuald Szauer on 19/3/26.
//

import Foundation

@Observable
class GameViewModel {
    var board: BoardViewModel
    
    init(
        boardSize: Int,
        game: any Chess.Game
    ) {
        board = .init(
            board: .init(size: boardSize),
            game: game
        )
    }
}
