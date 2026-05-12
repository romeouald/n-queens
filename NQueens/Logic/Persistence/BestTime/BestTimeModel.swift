//
//  BestTimeModel.swift
//  NQueens
//
//  Created by Romuald Szauer on 21/3/26.
//

import Foundation
import SwiftData

@Model
final class BestTimeModel {
    @Attribute(.unique) var key: String
    var bestTime: TimeInterval

    init(game: Chess.Game, boardSize: Int, bestTime: TimeInterval) {
        self.key = Self.key(game: game, boardSize: boardSize)
        self.bestTime = bestTime
    }
    
    static func key(game: Chess.Game, boardSize: Int) -> String {
        "\(game.modelName)-\(boardSize)"
    }
}

private extension Chess.Game {
    nonisolated
    var modelName: String {
        switch self {
        case .nQueens: "nqueens"
        case .nKnights: "nkights"
        }
    }
}
