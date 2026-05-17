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
        let store = BestTimeStoreSpy()
        let clock = TestClock()
        let game = Chess.Game.nQueens
        let engine = GameEngineSpy()

        @Test func boardSizeMatchesInput() {
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            #expect(vm.board.size == 4)
        }

        @Test func progressStartsAtZero() {
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            #expect(vm.progress.step == 0)
            #expect(vm.progress.total == 4)
        }

        @Test func gameIsNotFinishedOnInit() {
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            #expect(!vm.gameFinished)
        }

        @Test func hasNoErrorOnInit() {
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            #expect(!vm.hasError)
        }

        @Test func isNotInProgressOnInit() {
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            #expect(!vm.isGameInProgress)
        }

        @Test func elapsedTimeIsZeroBeforeStart() {
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            #expect(vm.elapsedTime == .zero)
        }

        @Test func loadsBestTimeFromStoreOnInit() {
            store.bestTimeStub = 42.0
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            #expect(vm.bestTime == .seconds(42))
        }

        @Test func bestTimeIsNilWhenStoreIsEmpty() {
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            #expect(vm.bestTime == nil)
        }

        @Test func feedbackIsNilOnInit() {
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            #expect(vm.feedback == nil)
        }
    }

    // MARK: - viewAppeared

    @Suite("viewAppeared")
    @MainActor
    struct ViewAppeared {
        let store = BestTimeStoreSpy()
        let clock = TestClock()
        let game = Chess.Game.nQueens
        let engine = GameEngineSpy()

        @Test func setsStartTime() {
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            #expect(vm.startTime == nil)
            vm.viewAppeared(dismiss: {})
            #expect(vm.startTime != nil)
        }

        @Test func doesNotOverwriteStartTimeOnSecondCall() {
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.viewAppeared(dismiss: {})
            let firstStartTime = vm.startTime
            clock.advance(by: .seconds(5))
            vm.viewAppeared(dismiss: {})
            #expect(vm.startTime == firstStartTime)
        }

        @Test func setsDismissAction() {
            var dismissed = false
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.viewAppeared(dismiss: { dismissed = true })
            vm.leavePromptConfimButtonTapped()
            #expect(dismissed)
        }
    }

    // MARK: - squareTapped

    @Suite("squareTapped")
    @MainActor
    struct SquareTapped {
        let store = BestTimeStoreSpy()
        let clock = TestClock()
        let game = Chess.Game.nQueens
        let engine = GameEngineSpy()

        @Test func forwardsIndexToGame() {
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.squareTapped(at: 5)
            #expect(engine.toggleSquareIndices == [5])
        }

        @Test func updatesProgressFromResult() {
            engine.toggleSquareStub = .stub(status: .normal, step: 2, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.squareTapped(at: 0)
            #expect(vm.progress.step == 2)
        }

        @Test func setsHasErrorWhenConflicting() {
            engine.toggleSquareStub = .stub(status: .conflicting)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.squareTapped(at: 0)
            #expect(vm.hasError)
        }

        @Test func doesNothingWhenGameAlreadyFinished() {
            engine.toggleSquareStub = .stub(status: .solved, step: 4, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.squareTapped(at: 0)
            vm.squareTapped(at: 1)
            #expect(engine.toggleSquareCallCount == 1)
        }

        @Test func isGameInProgressWhenStepAboveZeroAndNotFinished() {
            engine.toggleSquareStub = .stub(status: .normal, step: 1, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.squareTapped(at: 0)
            #expect(vm.isGameInProgress)
        }

        @Test func setsFeedbackFromMoveWhenGameNotFinished() {
            engine.toggleSquareStub = .stub(move: .place(conflicting: false), status: .normal, step: 1, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.squareTapped(at: 0)
            #expect(vm.feedback?.sound == .place)
        }

        @Test func setsFeedbackFromMoveWhenConflicting() {
            engine.toggleSquareStub = .stub(move: .place(conflicting: true), status: .conflicting, step: 1, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.squareTapped(at: 0)
            #expect(vm.feedback?.sound == .conflict)
        }

        @Test func setsFeedbackFromMoveOnRemove() {
            engine.toggleSquareStub = .stub(move: .remove, status: .normal, step: 0, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.squareTapped(at: 0)
            #expect(vm.feedback?.sound == .remove)
        }

        @Test func setsFeedbackFromMoveOnInvalid() {
            engine.toggleSquareStub = .stub(move: .invalid, status: .normal, step: 4, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.squareTapped(at: 0)
            #expect(vm.feedback?.sound == .invalid)
        }
    }

    // MARK: - squareTapped: game finished

    @Suite("squareTapped: game finished")
    @MainActor
    struct SquareTappedFinished {
        let store = BestTimeStoreSpy()
        let clock = TestClock()
        let game = Chess.Game.nQueens
        let engine = GameEngineSpy()

        @Test func setsFinishTime() {
            engine.toggleSquareStub = .stub(status: .solved, step: 4, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.viewAppeared(dismiss: {})
            vm.squareTapped(at: 0)
            #expect(vm.finishTime != nil)
        }

        @Test func setsSolvedFeedback() {
            engine.toggleSquareStub = .stub(status: .solved, step: 4, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.viewAppeared(dismiss: {})
            vm.squareTapped(at: 0)
            #expect(vm.feedback?.sound == .solved)
        }

        @Test func showsFirstWinOverlayWhenNoPreviousBestTime() {
            engine.toggleSquareStub = .stub(status: .solved, step: 4, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.viewAppeared(dismiss: {})
            vm.squareTapped(at: 0)
            #expect(vm.winOverlay == .first)
        }

        @Test func showsNewRecordOverlayWhenElapsedTimeBeatsBestTime() {
            store.bestTimeStub = 100.0
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.viewAppeared(dismiss: {})
            clock.advance(by: .seconds(10))
            engine.toggleSquareStub = .stub(status: .solved, step: 4, total: 4)
            vm.squareTapped(at: 0)
            #expect(vm.winOverlay == .newRecord)
        }

        @Test func showsSolvedOverlayWhenElapsedTimeDoesNotBeatBestTime() {
            store.bestTimeStub = 10.0
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.viewAppeared(dismiss: {})
            clock.advance(by: .seconds(100))
            engine.toggleSquareStub = .stub(status: .solved, step: 4, total: 4)
            vm.squareTapped(at: 0)
            #expect(vm.winOverlay == .solved)
        }

        @Test func savesBestTimeOnFirstSolution() {
            engine.toggleSquareStub = .stub(status: .solved, step: 4, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.viewAppeared(dismiss: {})
            vm.squareTapped(at: 0)
            #expect(store.saveBestTimeCallCount == 1)
            #expect(store.saveBestTimeInvocations.first?.boardSize == 4)
        }

        @Test func savesBestTimeOnNewRecord() {
            store.bestTimeStub = 100.0
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.viewAppeared(dismiss: {})
            clock.advance(by: .seconds(10))
            engine.toggleSquareStub = .stub(status: .solved, step: 4, total: 4)
            vm.squareTapped(at: 0)
            #expect(store.saveBestTimeCallCount == 1)
        }

        @Test func doesNotSaveBestTimeWhenNotImproved() {
            store.bestTimeStub = 10.0
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.viewAppeared(dismiss: {})
            clock.advance(by: .seconds(100))
            engine.toggleSquareStub = .stub(status: .solved, step: 4, total: 4)
            vm.squareTapped(at: 0)
            #expect(store.saveBestTimeCallCount == 0)
        }
    }

    // MARK: - winOverlayDismissed

    @Suite("winOverlayDismissed")
    @MainActor
    struct WinOverlayDismissed {
        let store = BestTimeStoreSpy()
        let clock = TestClock()
        let game = Chess.Game.nQueens
        let engine = GameEngineSpy()

        @Test func clearsWinOverlay() {
            engine.toggleSquareStub = .stub(status: .solved, step: 4, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
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
        let store = BestTimeStoreSpy()
        let clock = TestClock()
        let game = Chess.Game.nQueens
        let engine = GameEngineSpy()

        @Test func setsLeavePromptAlertWhenGameInProgress() {
            engine.toggleSquareStub = .stub(status: .normal, step: 1, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.squareTapped(at: 0)
            vm.backButtonTapped()
            #expect(vm.alert == .leavePrompt)
        }

        @Test func doesNotSetAlertWhenGameNotInProgress() {
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.backButtonTapped()
            #expect(vm.alert == nil)
        }

        @Test func callsDismissWhenGameNotInProgress() {
            var dismissed = false
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.viewAppeared(dismiss: { dismissed = true })
            vm.backButtonTapped()
            #expect(dismissed)
        }
    }

    // MARK: - leavePromptConfirmButtonTapped

    @Suite("leavePromptConfirmButtonTapped")
    @MainActor
    struct LeavePromptConfirmed {
        let store = BestTimeStoreSpy()
        let clock = TestClock()
        let game = Chess.Game.nQueens
        let engine = GameEngineSpy()

        @Test func callsDismiss() {
            var dismissed = false
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.viewAppeared(dismiss: { dismissed = true })
            vm.leavePromptConfimButtonTapped()
            #expect(dismissed)
        }
    }

    // MARK: - resetButtonTapped

    @Suite("resetButtonTapped")
    @MainActor
    struct ResetButtonTapped {
        let store = BestTimeStoreSpy()
        let clock = TestClock()
        let game = Chess.Game.nQueens
        let engine = GameEngineSpy()

        @Test func setsResetPromptAlertWhenGameInProgress() {
            engine.toggleSquareStub = .stub(status: .normal, step: 1, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.squareTapped(at: 0)
            vm.resetButtonTapped()
            #expect(vm.alert == .resetPrompt)
        }

        @Test func doesNotSetAlertWhenGameNotInProgress() {
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.resetButtonTapped()
            #expect(vm.alert == nil)
        }

        @Test func resetsGameWhenNotInProgress() {
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.resetButtonTapped()
            #expect(engine.resetCallCount == 1)
        }
    }

    // MARK: - resetPromptConfirmButtonTapped

    @Suite("resetPromptConfirmButtonTapped")
    @MainActor
    struct ResetPromptConfirmed {
        let store = BestTimeStoreSpy()
        let clock = TestClock()
        let game = Chess.Game.nQueens
        let engine = GameEngineSpy()

        @Test func resetsProgress() {
            engine.toggleSquareStub = .stub(status: .normal, step: 2, total: 4)
            engine.resetStub = .stub(status: .normal, step: 0, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.squareTapped(at: 0)
            vm.resetPromptConfirmButtonTapped()
            #expect(vm.progress.step == 0)
        }

        @Test func clearsFinishTime() {
            engine.toggleSquareStub = .stub(status: .solved, step: 4, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.viewAppeared(dismiss: {})
            vm.squareTapped(at: 0)
            vm.resetPromptConfirmButtonTapped()
            #expect(vm.finishTime == nil)
        }

        @Test func resetsStartTime() {
            engine.toggleSquareStub = .stub(status: .normal, step: 1, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.viewAppeared(dismiss: {})
            vm.squareTapped(at: 0)
            let firstStartTime = vm.startTime
            clock.advance(by: .seconds(5))
            vm.resetPromptConfirmButtonTapped()
            #expect(vm.startTime != firstStartTime)
        }

        @Test func reloadsBestTimeFromStore() {
            store.bestTimeStub = 99.0
            engine.resetStub = .stub(status: .normal, step: 0, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.resetPromptConfirmButtonTapped()
            #expect(vm.bestTime == .seconds(99))
        }

        @Test func callsResetOnGame() {
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.resetPromptConfirmButtonTapped()
            #expect(engine.resetCallCount == 1)
        }

        @Test func setsFeedbackFromResetMove() {
            engine.resetStub = .stub(move: .reset, status: .normal, step: 0, total: 4)
            let vm = GameViewModel(bestTimeStore: store, clock: clock, boardSize: 4, game: game, engine: engine)
            vm.resetPromptConfirmButtonTapped()
            #expect(vm.feedback?.sound == .reset)
        }
    }
}
