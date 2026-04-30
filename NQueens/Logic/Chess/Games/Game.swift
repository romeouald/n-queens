//
//  Game.swift
//  NQueens
//
//  Created by Romuald Szauer on 20/3/26.
//

extension Chess {
    enum Game {
        case nQueens
        case nKnights
    }
}
 
extension Chess.Game {
    protocol Engine {
        func toggleSquare(at index: Int, on board: inout Chess.Board) -> MoveResult
        func reset(board: inout Chess.Board) -> MoveResult
    }
    
    struct MoveResult {
        let move: Move
        let gameStatus: Status
        let progress: Progress
    }
    
    enum Move {
        case place(conflicting: Bool)
        case remove
        case invalid
        case reset
    }
    
    enum Status {
        case normal
        case conflicting
        case solved
    }
    
    struct Progress {
        let step: Int
        let total: Int
        
        var percentage: Double {
            Double(step) / Double(total)
        }
    }
}

extension Chess.Game {
    var engine: Engine {
        switch self {
        case .nQueens: NQueens()
        case .nKnights: NKnights()
        }
    }
}
