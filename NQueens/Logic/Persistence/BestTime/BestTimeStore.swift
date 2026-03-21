//
//  BestTimeStore.swift
//  NQueens
//
//  Created by Romuald Szauer on 21/3/26.
//

import Foundation
import SwiftData

class BestTimeStore: Sendable {
    private var context: ModelContext?
    
    init(context: ModelContext? = try? PersistentStore.Context.live) {
        self.context =  context
    }
    
    func bestTime(for boardSize: Int) -> TimeInterval? {
        let descriptor = FetchDescriptor<BestTimeModel>(
            predicate: #Predicate { $0.boardSize == boardSize }
        )
        
        return try? context?.fetch(descriptor).first?.bestTime
    }
    
    func saveBestTime(boardSize: Int, time: TimeInterval) {
        let entry = BestTimeModel(boardSize: boardSize, bestTime: time)
        context?.insert(entry)
        try? context?.save()
    }
}
