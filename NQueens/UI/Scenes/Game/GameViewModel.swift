//
//  GameViewModel.swift
//  NQueens
//
//  Created by Romuald Szauer on 19/3/26.
//

import Foundation

struct GameViewModel: Equatable, Hashable {
    var board: BoardViewModel
    
    init(boardSize: Int) {
        board = .init(board: .init(size: boardSize))
    }
}
