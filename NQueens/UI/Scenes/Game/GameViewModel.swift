//
//  GameViewModel.swift
//  NQueens
//
//  Created by Romuald Szauer on 19/3/26.
//

import Foundation
import SwiftUI

@Observable
final class GameViewModel<GameClock: Clock> where GameClock.Duration == Duration {
    private var bestTimeStore: any BestTimeStoring
    private var clock: GameClock

    private(set) var board: Chess.Board
    private var game: any Chess.Game.Engine
    
    private(set) var bestTime: Duration?
    private(set) var startTime: (GameClock.Instant)?
    private(set) var finishTime: (GameClock.Instant)?
    var elapsedTime: Duration {
        guard let startTime else { return .zero }
        return startTime.duration(to: finishTime ?? clock.now)
    }

    typealias Progress = Chess.Game.Progress
    private(set) var progress: Progress
    private var gameStatus: Chess.Game.Status
    var isGameInProgress: Bool { progress.step > 0 && !gameFinished }
    var hasError: Bool { gameStatus == .conflicting }
    var gameFinished: Bool { gameStatus == .solved }
    
    var winOverlay: WinOverlay.Style?
    
    enum Alert: Identifiable {
        var id: Self { self }
        case resetPrompt
        case leavePrompt
    }
    var alert: Alert?
    
    var feedback: Feedback?
    
    var dismiss: (() -> Void)?
    
    init(
        bestTimeStore: any BestTimeStoring = BestTimeStore(context: .live),
        clock: GameClock = .continuous,
        boardSize: Int,
        game: any Chess.Game.Engine
    ) {
        self.bestTimeStore = bestTimeStore
        self.clock = clock
        self.board = .init(size: boardSize)
        self.game = game
        
        if let bestTime = bestTimeStore.bestTime(for: boardSize) {
            self.bestTime = Duration.seconds(bestTime)
        }
        self.progress = .init(step: 0, total: boardSize)
        self.gameStatus = .normal
    }
    
    func viewAppeared(dismiss: @escaping (() -> Void)) {
        self.dismiss = dismiss
        self.startGameIfNeeded()
    }
    
    func squareTapped(at index: Int) {
        guard !gameFinished else { return }
        
        let result = game.toggleSquare(at: index, on: &board)
        gameStatus = result.gameStatus
        progress = result.progress
        
        if gameFinished {
            feedback = .init(sound: .solved, sensory: .success)
            finishTime = clock.now

            var updateBestTime: Bool
            var winOverlay: WinOverlay.Style
            
            if bestTime == nil {
                // first solution
                updateBestTime = true
                winOverlay = .first
            } else if elapsedTime < bestTime! {
                // new record
                updateBestTime = true
                winOverlay = .newRecord
            } else {
                // subsequent solution without best time
                updateBestTime = false
                winOverlay = .solved
            }
            
            if updateBestTime { bestTimeStore.saveBestTime(boardSize: board.size, time: elapsedTime.timeInterval) }
            
            withAnimation {
                self.winOverlay = winOverlay
            }
        } else {
            feedback = result.move.feedback
        }
    }
    
    func backButtonTapped() {
        guard !isGameInProgress else {
            alert = .leavePrompt
            return
        }
        
        dismiss?()
    }
    
    func resetButtonTapped() {
        guard !isGameInProgress else {
            alert = .resetPrompt
            return
        }
        
        resetGame()
    }

    func leavePromptConfimButtonTapped() {
        dismiss?()
    }
    
    func resetPromptConfirmButtonTapped() {
        resetGame()
    }
    
    func winOverlayDismissed() {
        winOverlay = nil
    }
    
    private func startGameIfNeeded() {
        guard startTime == nil else { return }
        startTime = clock.now
    }
    
    private func resetGame() {
        let result = game.reset(board: &board)
        gameStatus = result.gameStatus
        progress = result.progress
        feedback = result.move.feedback

        startTime = clock.now
        finishTime = nil

        if let bestTime = bestTimeStore.bestTime(for: board.size) {
            self.bestTime = Duration.seconds(bestTime)
        }
    }
}

extension Chess.Game.Move {
    var feedback: Feedback {
        switch self {
        case .place(conflicting: false): .init(sound: .place, sensory: .impact(flexibility: .soft, intensity: 1))
        case .place(conflicting: true): .init(sound: .conflict, sensory: .warning)
        case .remove: .init(sound: .remove, sensory: .impact(flexibility: .soft, intensity: 0.6))
        case .invalid: .init(sound: .invalid, sensory: .error)
        case .reset: .init(sound: .reset, sensory: .warning)
        }
    }
}

extension GameViewModel where GameClock == ContinuousClock {
    static var preview: GameViewModel {
        .init(
            bestTimeStore: BestTimeStore(context: .preview),
            boardSize: 4,
            game: NQueens()
        )
    }
}
