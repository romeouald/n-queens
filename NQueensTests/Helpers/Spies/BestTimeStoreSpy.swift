//
//  BestTimeStoreSpy.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

@testable import NQueens
import Foundation
import Testing

final class BestTimeStoreSpy: BestTimeStoring {

    // MARK: - bestTime(for:)

    private(set) var bestTimeCallCount = 0
    private(set) var bestTimeBoardSizes: [Int] = []
    var bestTimeStub: TimeInterval? = nil

    func bestTime(for boardSize: Int) -> TimeInterval? {
        bestTimeCallCount += 1
        bestTimeBoardSizes.append(boardSize)
        return bestTimeStub
    }

    // MARK: - saveBestTime(boardSize:time:)

    private(set) var saveBestTimeCallCount = 0
    private(set) var saveBestTimeInvocations: [(boardSize: Int, time: TimeInterval)] = []

    func saveBestTime(boardSize: Int, time: TimeInterval) {
        saveBestTimeCallCount += 1
        saveBestTimeInvocations.append((boardSize: boardSize, time: time))
    }
    
}
