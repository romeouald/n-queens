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

    // MARK: - bestTime(for:boardSize:)

    private(set) var bestTimeCallCount = 0
    private(set) var bestTimeGames: [Chess.Game] = []
    private(set) var bestTimeBoardSizes: [Int] = []
    var bestTimeStub: TimeInterval? = nil

    func bestTime(for game: Chess.Game, boardSize: Int) -> TimeInterval? {
        bestTimeCallCount += 1
        bestTimeGames.append(game)
        bestTimeBoardSizes.append(boardSize)
        return bestTimeStub
    }

    // MARK: - saveBestTime(game:boardSize:time:)

    private(set) var saveBestTimeCallCount = 0
    private(set) var saveBestTimeInvocations: [(game: Chess.Game, boardSize: Int, time: TimeInterval)] = []

    func saveBestTime(game: Chess.Game, boardSize: Int, time: TimeInterval) {
        saveBestTimeCallCount += 1
        saveBestTimeInvocations.append((game: game, boardSize: boardSize, time: time))
    }
    
}
