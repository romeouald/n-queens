//
//  BestTimeModel.swift
//  NQueens
//
//  Created by Romuald Szauer on 21/3/26.
//

import Foundation
import SwiftData

enum BestTimeSchemaV0: VersionedSchema {
    static let versionIdentifier: Schema.Version = .init(0, 0, 0)
    static let models: [any PersistentModel.Type] = [BestTimeModel.self]

    @Model
    final class BestTimeModel {
        @Attribute(.unique) var boardSize: Int
        var bestTime: TimeInterval

        init(boardSize: Int, bestTime: TimeInterval) {
            self.boardSize = boardSize
            self.bestTime = bestTime
        }
    }
}
