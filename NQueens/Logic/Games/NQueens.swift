//
//  NQueens.swift
//  NQueens
//
//  Created by Romuald Szauer on 20/3/26.
//

import Foundation

struct NQueens: Chess.Game {
    func squareTapped(at index: Int, on board: inout Chess.Board) {
        let square = board.squares[index]
        
        if square.piece == nil {
            board.setPiece(.init(type: .queen, color: .light), at: index)
        } else {
            board.removePiece(at: index)
        }
    }
}
