//
//  GameViewModelTests.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

@testable import NQueens
import Foundation
import Testing

@Suite("GameViewModel")
@MainActor
struct GameViewModelTests {

    // MARK: - Initial State

    @Suite("initial state")
    @MainActor
    struct InitialState {
        let clock = TestClock()
        let store = BestTimeStoreSpy()
        let game = GameSpy()

        @Test func boardSizeMatchesInput() {
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            #expect(vm.board.size == 4)
        }

        @Test func progressStartsAtZero() {
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            #expect(vm.progress.step == 0)
            #expect(vm.progress.total == 4)
        }

        @Test func gameIsNotFinishedOnInit() {
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            #expect(!vm.gameFinished)
        }

        @Test func hasNoErrorOnInit() {
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            #expect(!vm.hasError)
        }

        @Test func isNotInProgressOnInit() {
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            #expect(!vm.isGameInProgress)
        }

        @Test func elapsedTimeIsZeroBeforeStart() {
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            #expect(vm.elapsedTime == .zero)
        }

        @Test func loadsBestTimeFromStoreOnInit() {
            store.bestTimeStub = 42.0
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game)
            #expect(vm.bestTime == .seconds(42))
        }

        @Test func bestTimeIsNilWhenStoreIsEmpty() {
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game)
            #expect(vm.bestTime == nil)
        }
    }

    // MARK: - viewAppeared

    @Suite("viewAppeared")
    @MainActor
    struct ViewAppeared {
        let clock = TestClock()
        let game = GameSpy()

        @Test func setsStartTime() {
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            #expect(vm.startTime == nil)
            vm.viewAppeared(dismiss: {})
            #expect(vm.startTime != nil)
        }

        @Test func doesNotOverwriteStartTimeOnSecondCall() {
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.viewAppeared(dismiss: {})
            let firstStartTime = vm.startTime
            clock.advance(by: .seconds(5))
            vm.viewAppeared(dismiss: {})
            #expect(vm.startTime == firstStartTime)
        }

        @Test func setsDismissAction() {
            var dismissed = false
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.viewAppeared(dismiss: { dismissed = true })
            vm.leavePromptConfimButtonTapped()
            #expect(dismissed)
        }
    }

    // MARK: - squareTapped

    @Suite("squareTapped")
    @MainActor
    struct SquareTapped {
        let clock = TestClock()
        let game = GameSpy()

        @Test func forwardsIndexToGame() {
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.squareTapped(at: 5)
            #expect(game.squareTappedIndices == [5])
        }

        @Test func updatesProgressFromResult() {
            game.squareTappedStub = .stub(status: .normal, step: 2, total: 4)
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.squareTapped(at: 0)
            #expect(vm.progress.step == 2)
        }

        @Test func setsHasErrorWhenConflicting() {
            game.squareTappedStub = .stub(status: .conflicting)
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.squareTapped(at: 0)
            #expect(vm.hasError)
        }

        @Test func doesNothingWhenGameAlreadyFinished() {
            game.squareTappedStub = .stub(status: .solved, step: 4, total: 4)
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.squareTapped(at: 0)
            vm.squareTapped(at: 1)
            #expect(game.squareTappedCallCount == 1)
        }

        @Test func isGameInProgressWhenStepAboveZeroAndNotFinished() {
            game.squareTappedStub = .stub(status: .normal, step: 1, total: 4)
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.squareTapped(at: 0)
            #expect(vm.isGameInProgress)
        }
    }

    // MARK: - squareTapped: game finished

    @Suite("squareTapped: game finished")
    @MainActor
    struct SquareTappedFinished {
        let clock = TestClock()
        let store = BestTimeStoreSpy()
        let game = GameSpy()

        @Test func setsFinishTime() {
            game.squareTappedStub = .stub(status: .solved, step: 4, total: 4)
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.viewAppeared(dismiss: {})
            vm.squareTapped(at: 0)
            #expect(vm.finishTime != nil)
        }

        @Test func showsFirstWinOverlayWhenNoPreviousBestTime() {
            game.squareTappedStub = .stub(status: .solved, step: 4, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game)
            vm.viewAppeared(dismiss: {})
            vm.squareTapped(at: 0)
            #expect(vm.winOverlay == .first)
        }

        @Test func showsNewRecordOverlayWhenElapsedTimeBeatsBestTime() {
            store.bestTimeStub = 100.0
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game)
            vm.viewAppeared(dismiss: {})
            clock.advance(by: .seconds(10))
            game.squareTappedStub = .stub(status: .solved, step: 4, total: 4)
            vm.squareTapped(at: 0)
            #expect(vm.winOverlay == .newRecord)
        }

        @Test func showsSolvedOverlayWhenElapsedTimeDoesNotBeatBestTime() {
            store.bestTimeStub = 10.0
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game)
            vm.viewAppeared(dismiss: {})
            clock.advance(by: .seconds(100))
            game.squareTappedStub = .stub(status: .solved, step: 4, total: 4)
            vm.squareTapped(at: 0)
            #expect(vm.winOverlay == .solved)
        }

        @Test func savesBestTimeOnFirstSolution() {
            game.squareTappedStub = .stub(status: .solved, step: 4, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game)
            vm.viewAppeared(dismiss: {})
            vm.squareTapped(at: 0)
            #expect(store.saveBestTimeCallCount == 1)
            #expect(store.saveBestTimeInvocations.first?.boardSize == 4)
        }

        @Test func savesBestTimeOnNewRecord() {
            store.bestTimeStub = 100.0
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game)
            vm.viewAppeared(dismiss: {})
            clock.advance(by: .seconds(10))
            game.squareTappedStub = .stub(status: .solved, step: 4, total: 4)
            vm.squareTapped(at: 0)
            #expect(store.saveBestTimeCallCount == 1)
        }

        @Test func doesNotSaveBestTimeWhenNotImproved() {
            store.bestTimeStub = 10.0
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game)
            vm.viewAppeared(dismiss: {})
            clock.advance(by: .seconds(100))
            game.squareTappedStub = .stub(status: .solved, step: 4, total: 4)
            vm.squareTapped(at: 0)
            #expect(store.saveBestTimeCallCount == 0)
        }
    }

    // MARK: - winOverlayDismissed

    @Suite("winOverlayDismissed")
    @MainActor
    struct WinOverlayDismissed {
        let clock = TestClock()
        let store = BestTimeStoreSpy()
        let game = GameSpy()

        @Test func clearsWinOverlay() {
            game.squareTappedStub = .stub(status: .solved, step: 4, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game)
            vm.viewAppeared(dismiss: {})
            vm.squareTapped(at: 0)
            #expect(vm.winOverlay != nil)
            vm.winOverlayDismissed()
            #expect(vm.winOverlay == nil)
        }
    }

    // MARK: - backButtonTapped

    @Suite("backButtonTapped")
    @MainActor
    struct BackButtonTapped {
        let clock = TestClock()
        let game = GameSpy()

        @Test func setsLeavePromptAlertWhenGameInProgress() {
            game.squareTappedStub = .stub(status: .normal, step: 1, total: 4)
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.squareTapped(at: 0)
            vm.backButtonTapped()
            #expect(vm.alert == .leavePrompt)
        }

        @Test func doesNotSetAlertWhenGameNotInProgress() {
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.backButtonTapped()
            #expect(vm.alert == nil)
        }

        @Test func callsDismissWhenGameNotInProgress() {
            var dismissed = false
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.viewAppeared(dismiss: { dismissed = true })
            vm.backButtonTapped()
            #expect(dismissed)
        }
    }

    // MARK: - leavePromptConfirmButtonTapped

    @Suite("leavePromptConfirmButtonTapped")
    @MainActor
    struct LeavePromptConfirmed {
        let clock = TestClock()
        let game = GameSpy()

        @Test func callsDismiss() {
            var dismissed = false
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.viewAppeared(dismiss: { dismissed = true })
            vm.leavePromptConfimButtonTapped()
            #expect(dismissed)
        }
    }

    // MARK: - resetButtonTapped

    @Suite("resetButtonTapped")
    @MainActor
    struct ResetButtonTapped {
        let clock = TestClock()
        let game = GameSpy()

        @Test func setsResetPromptAlertWhenGameInProgress() {
            game.squareTappedStub = .stub(status: .normal, step: 1, total: 4)
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.squareTapped(at: 0)
            vm.resetButtonTapped()
            #expect(vm.alert == .resetPrompt)
        }

        @Test func doesNotSetAlertWhenGameNotInProgress() {
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.resetButtonTapped()
            #expect(vm.alert == nil)
        }

        @Test func resetsGameWhenNotInProgress() {
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.resetButtonTapped()
            #expect(game.resetCallCount == 1)
        }
    }

    // MARK: - resetPromptConfirmButtonTapped

    @Suite("resetPromptConfirmButtonTapped")
    @MainActor
    struct ResetPromptConfirmed {
        let clock = TestClock()
        let store = BestTimeStoreSpy()
        let game = GameSpy()

        @Test func resetsProgress() {
            game.squareTappedStub = .stub(status: .normal, step: 2, total: 4)
            game.resetStub = .stub(status: .normal, step: 0, total: 4)
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.squareTapped(at: 0)
            vm.resetPromptConfirmButtonTapped()
            #expect(vm.progress.step == 0)
        }

        @Test func clearsFinishTime() {
            game.squareTappedStub = .stub(status: .solved, step: 4, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game)
            vm.viewAppeared(dismiss: {})
            vm.squareTapped(at: 0)
            vm.resetPromptConfirmButtonTapped()
            #expect(vm.finishTime == nil)
        }

        @Test func resetsStartTime() {
            game.squareTappedStub = .stub(status: .normal, step: 1, total: 4)
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.viewAppeared(dismiss: {})
            vm.squareTapped(at: 0)
            let firstStartTime = vm.startTime
            clock.advance(by: .seconds(5))
            vm.resetPromptConfirmButtonTapped()
            #expect(vm.startTime != firstStartTime)
        }

        @Test func reloadsBestTimeFromStore() {
            store.bestTimeStub = 99.0
            game.resetStub = .stub(status: .normal, step: 0, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game)
            vm.resetPromptConfirmButtonTapped()
            #expect(vm.bestTime == .seconds(99))
        }

        @Test func callsResetOnGame() {
            let vm = GameViewModel(clock: clock, boardSize: 4, game: game)
            vm.resetPromptConfirmButtonTapped()
            #expect(game.resetCallCount == 1)
        }
    }
}
