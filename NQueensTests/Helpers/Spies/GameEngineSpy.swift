//
//  GameEngineSpy.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

@testable import NQueens
import Foundation

final class GameEngineSpy: Chess.Game.Engine {
    private(set) var toggleSquareCallCount = 0
    private(set) var toggleSquareIndices: [Int] = []
    var toggleSquareStub: Chess.Game.MoveResult = .stub()

    func toggleSquare(at index: Int, on board: inout Chess.Board) -> Chess.Game.MoveResult {
        toggleSquareCallCount += 1
        toggleSquareIndices.append(index)
        return toggleSquareStub
    }

    private(set) var resetCallCount = 0
    var resetStub: Chess.Game.MoveResult = .stub()

    func reset(board: inout Chess.Board) -> Chess.Game.MoveResult {
        resetCallCount += 1
        return resetStub
    }
}

extension Chess.Game.MoveResult {
    static func stub(
        status: Chess.Game.Status = .normal,
        step: Int = 0,
        total: Int = 4
    ) -> Self {
        .init(gameStatus: status, progress: .init(step: step, total: total))
    }
}
