//
//  NQueens.swift
//  NQueens
//
//  Created by Romuald Szauer on 20/3/26.
//

import Foundation

struct NQueens: Chess.Game {
    enum EvaluationResult {
        case normal
        case conflicts(indices: Set<Int>)
        case solved
    }
    
    func squareTapped(at index: Int, on board: inout Chess.Board) {
        let square = board.squares[index]
        
        if square.piece == nil {
            if canPlacePiece(on: board) {
                board.setPiece(.init(type: .queen, color: .light), at: index)
            }
        } else {
            board.removePiece(at: index)
        }
        
        board.removeAllConflicts()
        let result = evaluateGame(on: board)

        switch result {
        case .normal, .solved:
            break
        case .conflicts(let indices):
            board.setConflicts(at: indices)
        }
    }
    
    private func canPlacePiece(on board: Chess.Board) -> Bool {
        let numberOfQueens = board.squares
            .filter { $0.piece?.type == .queen }
            .count
        
        return numberOfQueens < board.size
    }
    
    private func evaluateGame(on board: Chess.Board) -> EvaluationResult {
        let queens = board.squares
            .enumerated()
            .filter { $0.element.piece?.type == .queen }
        
        var conflictingIndices = Set<Int>()
        
        var firstInRow = [Int: Int]()
        var firstInCol = [Int: Int]()
        var firstInPosDiag = [Int: Int]() // row + col
        var firstInNegDiag = [Int: Int]() // row - col
        
        for (i, queen) in queens {
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
        
        guard conflictingIndices.isEmpty else {
            return .conflicts(indices: conflictingIndices)
        }
        
        return .normal
    }
}
