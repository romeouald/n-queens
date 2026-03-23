//
//  NQueens.swift
//  NQueens
//
//  Created by Romuald Szauer on 20/3/26.
//

import Foundation

struct NQueens: Chess.Game.Engine {
    func toggleSquare(at index: Int, on board: inout Chess.Board) -> Chess.Game.MoveResult {
        let square = board.squares[index]
        
        let move: Chess.Game.Move
        if square.piece == nil {
            if canPlacePiece(on: board) {
                board.setPiece(.init(type: .queen, color: .light), at: index)
                move = .place
            } else {
                move = .invalid
            }
        } else {
            board.removePiece(at: index)
            move = .remove
        }
        
        return evaluate(board: &board, after: move)
    }
    
    func reset(board: inout Chess.Board) -> Chess.Game.MoveResult {
        board.reset()
        
        return .init(
            move: .reset,
            gameStatus: .normal,
            progress: .init(step: 0, total: board.size)
        )
    }
    
    private func canPlacePiece(on board: Chess.Board) -> Bool {
        return numberOfQueens(on: board) < board.size
    }
    
    private func numberOfQueens(on board: Chess.Board) -> Int {
        board.squares
            .filter { $0.piece?.type == .queen }
            .count
    }
    
    private func evaluate(board: inout Chess.Board, after move: Chess.Game.Move) -> Chess.Game.MoveResult {
        var conflictingIndices: Set<Int> = []
        var queenCount = 0
        
        var firstInRow = [Int: Int]()
        var firstInCol = [Int: Int]()
        var firstInPosDiag = [Int: Int]() // row + col
        var firstInNegDiag = [Int: Int]() // row - col
        
        for i in 0 ..< board.squares.count {
            guard board.squares[i].piece?.type == .queen else { continue }
            queenCount += 1
            
            let row = board.row(for: i)
            let column = board.column(for: i)
            let positiveDiagonal = row + column
            let negativeDiagonal = row - column
            
            if let first = firstInRow[row] {
                conflictingIndices.insert(first)
                conflictingIndices.insert(i)
            } else {
                firstInRow[row] = i
            }

            if let first = firstInCol[column] {
                conflictingIndices.insert(first)
                conflictingIndices.insert(i)
            } else {
                firstInCol[column] = i
            }

            if let first = firstInPosDiag[positiveDiagonal] {
                conflictingIndices.insert(first)
                conflictingIndices.insert(i)
            } else {
                firstInPosDiag[positiveDiagonal] = i
            }

            if let first = firstInNegDiag[negativeDiagonal] {
                conflictingIndices.insert(first)
                conflictingIndices.insert(i)
            } else {
                firstInNegDiag[negativeDiagonal] = i
            }
        }

        board.setConflicts(at: conflictingIndices)

        var gameStatus: Chess.Game.Status = .normal
        if !conflictingIndices.isEmpty {
            gameStatus = .conflicting
        } else if queenCount == board.size {
            gameStatus = .solved
        }
        
        return .init(
            move: move,
            gameStatus: gameStatus,
            progress: .init(step: queenCount, total: board.size)
        )
    }
}
