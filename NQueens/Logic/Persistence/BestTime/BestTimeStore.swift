//
//  BestTimeStore.swift
//  NQueens
//
//  Created by Romuald Szauer on 21/3/26.
//

import Foundation
import SwiftData

protocol BestTimeStoring {
    func bestTime(for game: Chess.Game, boardSize: Int) -> TimeInterval?
    func saveBestTime(game: Chess.Game, boardSize: Int, time: TimeInterval)
}

final class BestTimeStore: BestTimeStoring {
    private var context: ModelContext?
    
    init(context: ModelContext?) {
        self.context =  context
    }
    
    func bestTime(for game: Chess.Game, boardSize: Int) -> TimeInterval? {
        let key = BestTimeModel.key(game: game, boardSize: boardSize)
        let descriptor = FetchDescriptor<BestTimeModel>(
            predicate: #Predicate { $0.key == key }
        )
        
        return try? context?.fetch(descriptor).first?.bestTime
    }
    
    func saveBestTime(game: Chess.Game, boardSize: Int, time: TimeInterval) {
        let entry = BestTimeModel(game: game, boardSize: boardSize, bestTime: time)
        context?.insert(entry)
        try? context?.save()
    }
}
