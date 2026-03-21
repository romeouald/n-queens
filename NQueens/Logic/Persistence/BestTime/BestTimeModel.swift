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
    @Attribute(.unique) var boardSize: Int
    var bestTime: TimeInterval

    init(boardSize: Int, bestTime: TimeInterval) {
        self.boardSize = boardSize
        self.bestTime = bestTime
    }
}
