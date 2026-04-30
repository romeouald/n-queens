//
//  NKnights.swift
//  NQueens
//
//  Created by Romuald Szauer on 30/3/26.
//

import Foundation

struct NKnights: Chess.Game.Engine {
    func toggleSquare(at index: Int, on board: inout Chess.Board) -> Chess.Game.MoveResult {
        let square = board.squares[index]
        
        var move: Chess.Game.Move
        if square.piece == nil {
            if canPlacePiece(on: board) {
                board.setPiece(.init(figure: .knight, color: .light), at: index)
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
        } else if result.numberOfKnights == board.size {
            gameStatus = .solved
        }
        
        return .init(
            move: move,
            gameStatus: gameStatus,
            progress: .init(step: result.numberOfKnights, total: board.size)
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
        return numberOfKnights(on: board) < board.size
    }
    
    private func numberOfKnights(on board: Chess.Board) -> Int {
        board.squares
            .filter { $0.piece?.figure == .knight }
            .count
    }
    
    private struct EvaluationResult {
        let conflicts: Set<Int>
        let numberOfKnights: Int
    }
    
    static let attackOffsets: [(row: Int, col: Int)] = [
        (-2, -1), (-1, -2),
        (-2, +1), (-1, +2),
        (+2, -1), (+1, -2),
        (+2, +1), (+1, +2),
    ]
    
    private func evaluate(board: Chess.Board) -> EvaluationResult {
        var conflictingIndices: Set<Int> = []
        var knightCount = 0
        
        for i in 0 ..< board.squares.count {
            guard board.squares[i].piece?.figure == .knight else { continue }
            knightCount += 1
            
            let row = board.row(for: i)
            let col = board.column(for: i)
            
            for attackOffset in Self.attackOffsets {
                if let index = board.index(row: row + attackOffset.row, column: col + attackOffset.col) {
                    if board.squares[index].piece?.figure == .knight {
                        conflictingIndices.insert(i)
                        conflictingIndices.insert(index)
                    }
                }
            }
        }

        return .init(
            conflicts: conflictingIndices,
            numberOfKnights: knightCount
        )
    }
}
