//
//  Game.swift
//  NQueens
//
//  Created by Romuald Szauer on 20/3/26.
//

extension Chess {
    enum Game {}
}
 
extension Chess.Game {
    protocol Interface {
        func squareTapped(at index: Int, on board: inout Chess.Board) -> MoveResult
    }
    
    struct MoveResult {
        let gameStatus: Status
        let progress: Progress
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
