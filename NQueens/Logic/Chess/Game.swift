//
//  Game.swift
//  NQueens
//
//  Created by Romuald Szauer on 20/3/26.
//

extension Chess {
    enum GameResult {
        case ongoing(progress: Progress)
        case finished
        
        struct Progress {
            let step: Int
            let total: Int
            
            var percentage: Double {
                Double(step) / Double(total)
            }
        }
    }
    
    protocol Game {
        func squareTapped(at index: Int, on board: inout Board) -> GameResult
    }
}
