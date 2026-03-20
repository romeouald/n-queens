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
            if canPlacePiece(on: board) {
                board.setPiece(.init(type: .queen, color: .light), at: index)
            }
        } else {
            board.removePiece(at: index)
        }
    }
    
    private func canPlacePiece(on board: Chess.Board) -> Bool {
        let numberOfQueens = board.squares
            .filter { $0.piece?.type == .queen }
            .count
        
        return numberOfQueens < board.size
    }
}
