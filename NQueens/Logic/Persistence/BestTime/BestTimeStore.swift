//
//  BestTimeStore.swift
//  NQueens
//
//  Created by Romuald Szauer on 21/3/26.
//

import Foundation
import SwiftData

protocol BestTimeStoring {
    func bestTime(for boardSize: Int) -> TimeInterval?
    func saveBestTime(boardSize: Int, time: TimeInterval)
}

final class BestTimeStore: BestTimeStoring {
    private var context: ModelContext?
    
    init(context: ModelContext?) {
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
