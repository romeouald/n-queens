//
//  BoardTests.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

@testable import NQueens
import Testing

private extension Chess.Piece {
    static var lightQueen: Self { .init(type: .queen, color: .light) }
    static var darkQueen: Self { .init(type: .queen, color: .dark) }
}

@Suite("Chess.Board")
struct ChessBoardTests {

    // MARK: - Init

    @Suite("init")
    @MainActor
    struct Init {
        @Test func sizeIsSet() {
            let board = Chess.Board(size: 4)
            #expect(board.size == 4)
        }

        @Test func squaresCountEqualsSizeSquared() {
            let board = Chess.Board(size: 4)
            #expect(board.squares.count == 16)
        }

        @Test func allSquaresAreEmpty() {
            let board = Chess.Board(size: 4)
            #expect(board.squares.allSatisfy { $0.piece == nil })
        }

        @Test func allSquaresHaveNoConflict() {
            let board = Chess.Board(size: 4)
            #expect(board.squares.allSatisfy { !$0.hasConflict })
        }

        @Test(arguments: [1, 4, 8, 12])
        func variousSizesInitializeCorrectly(size: Int) {
            let board = Chess.Board(size: size)
            #expect(board.squares.count == size * size)
        }
    }

    // MARK: - row(for:)

    @Suite("row(for:)")
    @MainActor
    struct Row {
        let board = Chess.Board(size: 4)

        @Test func firstIndexIsRowZero() {
            #expect(board.row(for: 0) == 0)
        }

        @Test func lastIndexOfFirstRowIsRowZero() {
            #expect(board.row(for: 3) == 0)
        }

        @Test func firstIndexOfSecondRowIsRowOne() {
            #expect(board.row(for: 4) == 1)
        }

        @Test func lastIndexIsLastRow() {
            #expect(board.row(for: 15) == 3)
        }

        @Test(arguments: zip(0..<16, [0,0,0,0, 1,1,1,1, 2,2,2,2, 3,3,3,3]))
        func rowForIndex(index: Int, expectedRow: Int) {
            #expect(board.row(for: index) == expectedRow)
        }
    }

    // MARK: - column(for:)

    @Suite("column(for:)")
    @MainActor
    struct Column {
        let board = Chess.Board(size: 4)

        @Test func firstIndexIsColumnZero() {
            #expect(board.column(for: 0) == 0)
        }

        @Test func secondIndexIsColumnOne() {
            #expect(board.column(for: 1) == 1)
        }

        @Test func firstIndexOfSecondRowIsColumnZero() {
            #expect(board.column(for: 4) == 0)
        }

        @Test func lastIndexIsLastColumn() {
            #expect(board.column(for: 15) == 3)
        }

        @Test(arguments: zip(0..<16, [0,1,2,3, 0,1,2,3, 0,1,2,3, 0,1,2,3]))
        func columnForIndex(index: Int, expectedColumn: Int) {
            #expect(board.column(for: index) == expectedColumn)
        }
    }

    // MARK: - setPiece

    @Suite("setPiece")
    @MainActor
    struct SetPiece {
        @Test func placesPieceAtIndex() {
            var board = Chess.Board(size: 4)
            board.setPiece(.lightQueen, at: 0)
            #expect(board.squares[0].piece?.type == .queen)
            #expect(board.squares[0].piece?.color == .light)
        }

        @Test func doesNotAffectOtherSquares() {
            var board = Chess.Board(size: 4)
            board.setPiece(.lightQueen, at: 5)
            let otherSquares = board.squares.indices.filter { $0 != 5 }
            #expect(otherSquares.allSatisfy { board.squares[$0].piece == nil })
        }

        @Test func overwritesExistingPiece() {
            var board = Chess.Board(size: 4)
            board.setPiece(.lightQueen, at: 0)
            board.setPiece(.darkQueen, at: 0)
            #expect(board.squares[0].piece?.type == .queen)
            #expect(board.squares[0].piece?.color == .dark)
        }
    }

    // MARK: - removePiece

    @Suite("removePiece")
    @MainActor
    struct RemovePiece {
        @Test func removesPieceAtIndex() {
            var board = Chess.Board(size: 4)
            board.setPiece(.lightQueen, at: 3)
            board.removePiece(at: 3)
            #expect(board.squares[3].piece == nil)
        }

        @Test func doesNotAffectOtherSquares() {
            var board = Chess.Board(size: 4)
            board.setPiece(.lightQueen, at: 0)
            board.setPiece(.lightQueen, at: 5)
            board.removePiece(at: 5)
            #expect(board.squares[0].piece?.type == .queen)
            #expect(board.squares[0].piece?.color == .light)
        }

        @Test func removingFromEmptySquareDoesNotCrash() {
            var board = Chess.Board(size: 4)
            board.removePiece(at: 0)
            #expect(board.squares[0].piece == nil)
        }
    }

    // MARK: - removeAllPieces

    @Suite("removeAllPieces")
    @MainActor
    struct RemoveAllPieces {
        @Test func removesAllPlacedPieces() {
            var board = Chess.Board(size: 4)
            board.setPiece(.lightQueen, at: 0)
            board.setPiece(.lightQueen, at: 5)
            board.setPiece(.lightQueen, at: 10)
            board.removeAllPieces()
            #expect(board.squares.allSatisfy { $0.piece == nil })
        }

        @Test func callingOnEmptyBoardDoesNotCrash() {
            var board = Chess.Board(size: 4)
            board.removeAllPieces()
            #expect(board.squares.allSatisfy { $0.piece == nil })
        }
    }

    // MARK: - setConflicts

    @Suite("setConflicts")
    @MainActor
    struct SetConflicts {
        @Test func setsConflictAtGivenIndices() {
            var board = Chess.Board(size: 4)
            board.setConflicts(at: [0, 3, 7])
            #expect(board.squares[0].hasConflict)
            #expect(board.squares[3].hasConflict)
            #expect(board.squares[7].hasConflict)
        }

        @Test func doesNotSetConflictOnOtherSquares() {
            var board = Chess.Board(size: 4)
            board.setConflicts(at: [0])
            let otherSquares = board.squares.indices.filter { $0 != 0 }
            #expect(otherSquares.allSatisfy { !board.squares[$0].hasConflict })
        }

        @Test func emptySetDoesNotSetAnyConflicts() {
            var board = Chess.Board(size: 4)
            board.setConflicts(at: [])
            #expect(board.squares.allSatisfy { !$0.hasConflict })
        }

        @Test func doesNotAffectPieces() {
            var board = Chess.Board(size: 4)
            board.setPiece(.lightQueen, at: 0)
            board.setConflicts(at: [0, 1])
            #expect(board.squares[0].piece?.type == .queen)
            #expect(board.squares[0].piece?.color == .light)
        }
    }

    // MARK: - removeAllConflicts

    @Suite("removeAllConflicts")
    @MainActor
    struct RemoveAllConflicts {
        @Test func removesAllConflicts() {
            var board = Chess.Board(size: 4)
            board.setConflicts(at: [0, 5, 10, 15])
            board.removeAllConflicts()
            #expect(board.squares.allSatisfy { !$0.hasConflict })
        }

        @Test func doesNotAffectPieces() {
            var board = Chess.Board(size: 4)
            board.setPiece(.lightQueen, at: 0)
            board.setConflicts(at: [0])
            board.removeAllConflicts()
            #expect(board.squares[0].piece?.type == .queen)
        }

        @Test func callingOnBoardWithNoConflictsDoesNotCrash() {
            var board = Chess.Board(size: 4)
            board.removeAllConflicts()
            #expect(board.squares.allSatisfy { !$0.hasConflict })
        }
    }

}
