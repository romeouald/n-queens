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
        
        var move: Chess.Game.Move
        if square.piece == nil {
            if canPlacePiece(on: board) {
                board.setPiece(.init(figure: .queen, color: .light), at: index)
                move = .place(conflicting: false)
            } else {
                move = .invalid
            }
        } else {
            board.removePiece(at: index)
            move = .remove
        }
        
        let result = evaluate(board: board)
        
        board.setConflicts(at: result.conflicts)

        if case .place = move, result.conflicts.contains(index) {
            move = .place(conflicting: true)
        }
        
        var gameStatus: Chess.Game.Status = .normal
        if !result.conflicts.isEmpty {
            gameStatus = .conflicting
        } else if result.numberOfQueens == board.size {
            gameStatus = .solved
        }
        
        return .init(
            move: move,
            gameStatus: gameStatus,
            progress: .init(step: result.numberOfQueens, total: board.size)
        )
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
            .filter { $0.piece?.figure == .queen }
            .count
    }
    
    private struct EvaluationResult {
        let conflicts: Set<Int>
        let numberOfQueens: Int
    }
    
    private func evaluate(board: Chess.Board) -> EvaluationResult {
        var conflictingIndices: Set<Int> = []
        var queenCount = 0
        
        var firstInRow = [Int: Int]()
        var firstInCol = [Int: Int]()
        var firstInPosDiag = [Int: Int]() // row + col
        var firstInNegDiag = [Int: Int]() // row - col
        
        for i in 0 ..< board.squares.count {
            guard board.squares[i].piece?.figure == .queen else { continue }
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

        return .init(
            conflicts: conflictingIndices,
            numberOfQueens: queenCount
        )
    }
}
