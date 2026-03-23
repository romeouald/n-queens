//
//  ConfigurationViewModelTests.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

@testable import NQueens
import Testing
import Foundation

@Suite("ConfigurationViewModel")
@MainActor
struct ConfigurationViewModelTests {

    // MARK: - Initial State

    @Suite("initial state")
    @MainActor
    struct InitialState {
        @Test func defaultBoardSizeIsFour() {
            let vm = ConfigurationViewModel(bestTimeStore: BestTimeStoreSpy())
            #expect(vm.boardSize == 8)
        }

        @Test func destinationIsNilOnInit() {
            let vm = ConfigurationViewModel(bestTimeStore: BestTimeStoreSpy())
            #expect(vm.destination == nil)
        }
    }

    // MARK: - Best Time

    @Suite("bestTime")
    @MainActor
    struct BestTime {
        @Test func returnsNilWhenStoreHasNoBestTime() {
            let store = BestTimeStoreSpy()
            store.bestTimeStub = nil
            let vm = ConfigurationViewModel(bestTimeStore: store)

            #expect(vm.bestTime == nil)
        }

        @Test func returnsConvertedDurationWhenStoreHasBestTime() {
            let store = BestTimeStoreSpy()
            store.bestTimeStub = 42.0
            let vm = ConfigurationViewModel(bestTimeStore: store)

            #expect(vm.bestTime == .seconds(42))
        }

        @Test func queriesStoreWithCurrentBoardSize() {
            let store = BestTimeStoreSpy()
            let vm = ConfigurationViewModel(bestTimeStore: store)
            vm.boardSize = 6

            _ = vm.bestTime

            #expect(store.bestTimeBoardSizes == [6])
        }

        @Test func requeriesStoreWhenBoardSizeChanges() {
            let store = BestTimeStoreSpy()
            let vm = ConfigurationViewModel(bestTimeStore: store)

            vm.boardSize = 6
            _ = vm.bestTime

            vm.boardSize = 10
            _ = vm.bestTime

            #expect(store.bestTimeBoardSizes == [6, 10])
        }
    }

    // MARK: - Start Button

    @Suite("startButtonTapped")
    @MainActor
    struct StartButton {
        @Test func setsDestinationToGame() {
            let vm = ConfigurationViewModel(bestTimeStore: BestTimeStoreSpy())
            vm.startButtonTapped()

            #expect(vm.destination == .game(boardSize: 8))
        }

        @Test func destinationCarriesCurrentBoardSize() {
            let vm = ConfigurationViewModel(bestTimeStore: BestTimeStoreSpy())
            vm.boardSize = 10
            vm.startButtonTapped()

            #expect(vm.destination == .game(boardSize: 10))
        }
    }
}
