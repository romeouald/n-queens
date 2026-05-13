//
//  BestTimeModel.swift
//  NQueens
//
//  Created by Romuald Szauer on 21/3/26.
//

import Foundation
import SwiftData

enum BestTimeSchemaV2: VersionedSchema {
    static let versionIdentifier: Schema.Version = .init(2, 0, 0)
    static let models: [any PersistentModel.Type] = [BestTimeModel.self]

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
