//
//  BestTimeStoreTests.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

@testable import NQueens
import Testing
import SwiftData
import Foundation

@Suite("BestTimeStore")
@MainActor
struct BestTimeStoreTests {

    // MARK: - bestTime(for:)

    @Suite("bestTime(for:)")
    @MainActor
    struct BestTimeFor {
        @Test func returnsNilWhenNoEntryExists() {
            let store = BestTimeStore(context: .test)
            #expect(store.bestTime(for: 4) == nil)
        }

        @Test func returnsStoredTimeForMatchingBoardSize() {
            let store = BestTimeStore(context: .test)
            store.saveBestTime(boardSize: 4, time: 42.0)
            #expect(store.bestTime(for: 4) == 42.0)
        }

        @Test func returnsNilForDifferentBoardSize() {
            let store = BestTimeStore(context: .test)
            store.saveBestTime(boardSize: 4, time: 42.0)
            #expect(store.bestTime(for: 8) == nil)
        }

        @Test func returnsCorrectTimeWhenMultipleSizesStored() {
            let store = BestTimeStore(context: .test)
            store.saveBestTime(boardSize: 4, time: 42.0)
            store.saveBestTime(boardSize: 8, time: 99.0)
            #expect(store.bestTime(for: 4) == 42.0)
            #expect(store.bestTime(for: 8) == 99.0)
        }
    }

    // MARK: - saveBestTime(boardSize:time:)

    @Suite("saveBestTime(boardSize:time:)")
    @MainActor
    struct SaveBestTime {
        @Test func persistsTimeForBoardSize() {
            let store = BestTimeStore(context: .test)
            store.saveBestTime(boardSize: 4, time: 55.0)
            #expect(store.bestTime(for: 4) == 55.0)
        }

        @Test func canSaveMultipleDifferentBoardSizes() {
            let store = BestTimeStore(context: .test)
            store.saveBestTime(boardSize: 4, time: 10.0)
            store.saveBestTime(boardSize: 6, time: 20.0)
            store.saveBestTime(boardSize: 8, time: 30.0)
            #expect(store.bestTime(for: 4) == 10.0)
            #expect(store.bestTime(for: 6) == 20.0)
            #expect(store.bestTime(for: 8) == 30.0)
        }

        @Test func savingAgainForSameSizeOverwritesPreviousEntry() {
            let store = BestTimeStore(context: .test)
            store.saveBestTime(boardSize: 4, time: 100.0)
            #expect(store.bestTime(for: 4) == 100.0)
            store.saveBestTime(boardSize: 4, time: 50.0)
            #expect(store.bestTime(for: 4) == 50)
        }
    }

    // MARK: - nil context

    @Suite("nil context")
    @MainActor
    struct NilContext {
        // If BestTimeStore is initialized with a nil context
        // (eg.: when the ModelContainer fails to initialize),
        // the store degrades gracefully: it neither persists nor retrieves anything.
        
        @Test func bestTimeReturnsNilWhenContextIsNil() {
            let store = BestTimeStore(context: nil)
            #expect(store.bestTime(for: 4) == nil)
        }

        @Test func saveBestTimeDoesNotCrashWhenContextIsNil() {
            let store = BestTimeStore(context: nil)
            store.saveBestTime(boardSize: 4, time: 42.0)
            #expect(store.bestTime(for: 4) == nil)
        }
    }
}
