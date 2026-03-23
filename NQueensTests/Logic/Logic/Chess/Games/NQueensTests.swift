//
//  NQueensTests.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

@testable import NQueens
import Testing
import Foundation

@Suite("NQueens")
@MainActor
struct NQueensTests {

    // MARK: - toggleSquare: placing a queen

    @Suite("toggleSquare: placing a queen")
    @MainActor
    struct PlacingAQueen {
        var game = NQueens()

        @Test func placesQueenOnEmptySquare() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board)
            #expect(board.squares[0].piece?.type == .queen)
        }

        @Test func placedQueenIsLightColored() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board)
            #expect(board.squares[0].piece?.color == .light)
        }

        @Test func returnsMovePlace() {
            var board = Chess.Board(size: 4)
            let result = game.toggleSquare(at: 0, on: &board)
            if case .place = result.move { } else {
                Issue.record("Expected .place move, got \(result.move)")
            }
        }

        @Test func returnsPlaceConflictingFalseWhenNoConflict() {
            var board = Chess.Board(size: 4)
            let result = game.toggleSquare(at: 0, on: &board)
            if case .place(let conflicting) = result.move {
                #expect(!conflicting)
            } else {
                Issue.record("Expected .place move, got \(result.move)")
            }
        }

        @Test func returnsPlaceConflictingTrueWhenPlacedInConflict() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board) // row 0, col 0
            let result = game.toggleSquare(at: 1, on: &board) // row 0, col 1 — conflict
            if case .place(let conflicting) = result.move {
                #expect(conflicting)
            } else {
                Issue.record("Expected .place move, got \(result.move)")
            }
        }

        @Test func doesNotPlaceQueenWhenBoardIsFull() {
            var board = Chess.Board(size: 4)
            [0, 5, 10, 15].forEach { _ = game.toggleSquare(at: $0, on: &board) }
            _ = game.toggleSquare(at: 1, on: &board)
            let queenCount = board.squares.filter { $0.piece?.type == .queen }.count
            #expect(queenCount == 4)
        }

        @Test func returnsInvalidMoveWhenBoardIsFull() {
            var board = Chess.Board(size: 4)
            [0, 5, 10, 15].forEach { _ = game.toggleSquare(at: $0, on: &board) }
            let result = game.toggleSquare(at: 1, on: &board)
            if case .invalid = result.move { } else {
                Issue.record("Expected .invalid move, got \(result.move)")
            }
        }

        @Test func doesNotPlaceQueenBeyondBoardSize() {
            var board = Chess.Board(size: 2)
            [0, 3].forEach { _ = game.toggleSquare(at: $0, on: &board) }
            _ = game.toggleSquare(at: 1, on: &board)
            let queenCount = board.squares.filter { $0.piece?.type == .queen }.count
            #expect(queenCount == 2)
        }
    }

    // MARK: - toggleSquare: removing a queen

    @Suite("toggleSquare: removing a queen")
    @MainActor
    struct RemovingAQueen {
        var game = NQueens()

        @Test func removesQueenFromOccupiedSquare() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board)
            _ = game.toggleSquare(at: 0, on: &board)
            #expect(board.squares[0].piece == nil)
        }

        @Test func returnsMoveRemove() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board)
            let result = game.toggleSquare(at: 0, on: &board)
            if case .remove = result.move { } else {
                Issue.record("Expected .remove move, got \(result.move)")
            }
        }

        @Test func allowsPlacingNewQueenAfterRemoval() {
            var board = Chess.Board(size: 4)
            [0, 5, 10, 15].forEach { _ = game.toggleSquare(at: $0, on: &board) }
            _ = game.toggleSquare(at: 0, on: &board) // remove
            _ = game.toggleSquare(at: 1, on: &board) // should be allowed now
            #expect(board.squares[1].piece?.type == .queen)
        }
    }

    // MARK: - toggleSquare: progress

    @Suite("toggleSquare: progress")
    @MainActor
    struct Progress {
        var game = NQueens()

        @Test func progressStepIncrementsOnPlace() {
            var board = Chess.Board(size: 4)
            let result = game.toggleSquare(at: 0, on: &board)
            #expect(result.progress.step == 1)
        }

        @Test func progressTotalMatchesBoardSize() {
            var board = Chess.Board(size: 4)
            let result = game.toggleSquare(at: 0, on: &board)
            #expect(result.progress.total == 4)
        }

        @Test func progressStepDecrementsOnRemove() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board)
            _ = game.toggleSquare(at: 5, on: &board)
            let result = game.toggleSquare(at: 0, on: &board)
            #expect(result.progress.step == 1)
        }

        @Test func progressStepIsZeroOnEmptyBoard() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board)
            let result = game.toggleSquare(at: 0, on: &board)
            #expect(result.progress.step == 0)
        }

        @Test func progressUnchangedOnInvalidMove() {
            var board = Chess.Board(size: 4)
            [0, 5, 10, 15].forEach { _ = game.toggleSquare(at: $0, on: &board) }
            let result = game.toggleSquare(at: 1, on: &board) // invalid
            #expect(result.progress.step == 4)
        }
    }

    // MARK: - toggleSquare: game status

    @Suite("toggleSquare: game status")
    @MainActor
    struct GameStatus {
        var game = NQueens()

        @Test func statusIsNormalWithNoConflicts() {
            var board = Chess.Board(size: 4)
            let result = game.toggleSquare(at: 0, on: &board)
            #expect(result.gameStatus == .normal)
        }

        @Test func statusIsConflictingWhenQueensShareRow() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board) // row 0, col 0
            let result = game.toggleSquare(at: 1, on: &board) // row 0, col 1
            #expect(result.gameStatus == .conflicting)
        }

        @Test func statusIsConflictingWhenQueensShareColumn() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board) // row 0, col 0
            let result = game.toggleSquare(at: 4, on: &board) // row 1, col 0
            #expect(result.gameStatus == .conflicting)
        }

        @Test func statusIsConflictingWhenQueensSharePositiveDiagonal() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 1, on: &board) // row 0, col 1 — diag 1
            let result = game.toggleSquare(at: 4, on: &board) // row 1, col 0 — diag 1
            #expect(result.gameStatus == .conflicting)
        }

        @Test func statusIsConflictingWhenQueensShareNegativeDiagonal() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board) // row 0, col 0 — diag 0
            let result = game.toggleSquare(at: 5, on: &board) // row 1, col 1 — diag 0
            #expect(result.gameStatus == .conflicting)
        }

        @Test func statusIsSolvedForKnown4x4Solution() {
            var board = Chess.Board(size: 4)
            // Known 4-queens solution: columns 1,3,0,2
            _ = game.toggleSquare(at: 1, on: &board)  // row 0, col 1
            _ = game.toggleSquare(at: 7, on: &board)  // row 1, col 3
            _ = game.toggleSquare(at: 8, on: &board)  // row 2, col 0
            let result = game.toggleSquare(at: 14, on: &board) // row 3, col 2
            #expect(result.gameStatus == .solved)
        }

        @Test func statusIsSolvedForAlternate4x4Solution() {
            var board = Chess.Board(size: 4)
            // Second known solution: columns 2,0,3,1
            _ = game.toggleSquare(at: 2, on: &board)  // row 0, col 2
            _ = game.toggleSquare(at: 4, on: &board)  // row 1, col 0
            _ = game.toggleSquare(at: 11, on: &board) // row 2, col 3
            let result = game.toggleSquare(at: 13, on: &board) // row 3, col 1
            #expect(result.gameStatus == .solved)
        }

        @Test func statusReturnsToNormalAfterRemovingConflictingQueen() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board)
            _ = game.toggleSquare(at: 1, on: &board) // conflict
            let result = game.toggleSquare(at: 1, on: &board) // remove
            #expect(result.gameStatus == .normal)
        }
    }

    // MARK: - toggleSquare: conflicts on board

    @Suite("toggleSquare: conflicts on board")
    @MainActor
    struct Conflicts {
        var game = NQueens()

        @Test func conflictingSquaresAreMarked() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board) // row 0, col 0
            _ = game.toggleSquare(at: 1, on: &board) // row 0, col 1 — same row
            #expect(board.squares[0].hasConflict)
            #expect(board.squares[1].hasConflict)
        }

        @Test func nonConflictingSquaresAreNotMarked() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board)
            _ = game.toggleSquare(at: 1, on: &board)
            let unmarked = board.squares.indices.filter { $0 != 0 && $0 != 1 }
            #expect(unmarked.allSatisfy { !board.squares[$0].hasConflict })
        }

        @Test func conflictsAreClearedAfterRemovingConflictingQueen() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board)
            _ = game.toggleSquare(at: 1, on: &board) // conflict
            _ = game.toggleSquare(at: 1, on: &board) // remove
            #expect(board.squares.allSatisfy { !$0.hasConflict })
        }

        @Test func conflictsAreRecalculatedOnEachToggle() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board)  // row 0, col 0
            _ = game.toggleSquare(at: 7, on: &board)  // row 1, col 3 — no conflict with 0
            _ = game.toggleSquare(at: 1, on: &board)  // row 0, col 1 — now 0 and 1 conflict (same row)
            #expect(board.squares[0].hasConflict)
            #expect(board.squares[1].hasConflict)
            #expect(!board.squares[7].hasConflict)
        }
    }

    // MARK: - reset

    @Suite("reset")
    @MainActor
    struct Reset {
        var game = NQueens()

        @Test func removesAllPieces() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board)
            _ = game.toggleSquare(at: 5, on: &board)
            _ = game.reset(board: &board)
            #expect(board.squares.allSatisfy { $0.piece == nil })
        }

        @Test func removesAllConflicts() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board)
            _ = game.toggleSquare(at: 1, on: &board) // create conflict
            _ = game.reset(board: &board)
            #expect(board.squares.allSatisfy { !$0.hasConflict })
        }

        @Test func returnsResetMove() {
            var board = Chess.Board(size: 4)
            let result = game.reset(board: &board)
            if case .reset = result.move { } else {
                Issue.record("Expected .reset move, got \(result.move)")
            }
        }

        @Test func returnsNormalStatus() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board)
            let result = game.reset(board: &board)
            #expect(result.gameStatus == .normal)
        }

        @Test func returnsZeroProgress() {
            var board = Chess.Board(size: 4)
            _ = game.toggleSquare(at: 0, on: &board)
            let result = game.reset(board: &board)
            #expect(result.progress.step == 0)
        }

        @Test func progressTotalMatchesBoardSize() {
            var board = Chess.Board(size: 4)
            let result = game.reset(board: &board)
            #expect(result.progress.total == 4)
        }

        @Test func canPlaceQueenAfterReset() {
            var board = Chess.Board(size: 4)
            [0, 5, 10, 15].forEach { _ = game.toggleSquare(at: $0, on: &board) }
            _ = game.reset(board: &board)
            _ = game.toggleSquare(at: 0, on: &board)
            #expect(board.squares[0].piece?.type == .queen)
        }
    }

    // MARK: - Performance

    @Suite("performance")
    @MainActor
    struct Performance {
        // Measures the cost of a single toggleSquare call on a fully populated 64x64 board,
        // which forces a full conflict re-evaluation pass across all 4096 squares.
        //
        // The test runs 100 passes and expects the total under 0.5s, meaning each individual
        // call must complete in under 5ms. For reference, a 120Hz display has ~8.3ms per frame,
        // so a single evaluation must not become the bottleneck in the render loop.
        //
        // Benchmarks (100 passes):
        //   MacBook Pro M1 Pro:   0.121s (~1.21ms per call)
        //   iPhone 15 Pro Max:    0.097s (~0.97ms per call)
        @Test func evaluationOnLargeBoardCompletesWithinTimeLimit() {
            let game = NQueens()
            var board = Chess.Board(size: 64)
            var rng = SystemRandomNumberGenerator()

            // Place 64 queens at random positions (one per row to ensure count = board size)
            let indices = (0..<64).map { $0 * 64 + Int.random(in: 0..<64, using: &rng) }
            // indices.forEach { _ = game.toggleSquare(at: $0, on: &board) }
            indices.forEach { board.setPiece(.init(type: .queen, color: .light), at: $0) }

            let clock = ContinuousClock()
            let elapsed = clock.measure {
                for _ in 0..<100 {
                    _ = game.toggleSquare(at: indices[0], on: &board)
                }
            }

            print("elapsed: \(elapsed)")
            #expect(elapsed < .seconds(0.5))
        }
    }
}
