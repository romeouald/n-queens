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
        
        if square.piece == nil {
            if canPlacePiece(on: board) {
                board.setPiece(.init(type: .queen, color: .light), at: index)
            }
        } else {
            board.removePiece(at: index)
        }
        
        return evaluateGame(on: &board)
    }
    
    func reset(board: inout Chess.Board) -> Chess.Game.MoveResult {
        board.removeAllConflicts()
        board.removeAllPieces()
        
        return .init(
            gameStatus: .normal,
            progress: .init(step: 0, total: board.size)
        )
    }
    
    private func canPlacePiece(on board: Chess.Board) -> Bool {
        let numberOfQueens = board.squares
            .filter { $0.piece?.type == .queen }
            .count
        
        return numberOfQueens < board.size
    }
    
    private func evaluateGame(on board: inout Chess.Board) -> Chess.Game.MoveResult {
        board.removeAllConflicts()
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
        
        var gameStatus: Chess.Game.Status = .normal
        if !conflictingIndices.isEmpty {
            board.setConflicts(at: conflictingIndices)
            gameStatus = .conflicting
        } else if queenCount == board.size {
            gameStatus = .solved
        }
        
        return .init(
            gameStatus: gameStatus,
            progress: .init(step: queenCount, total: board.size)
        )
    }
}
