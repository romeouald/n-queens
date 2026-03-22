//
//  GameViewModel.swift
//  NQueens
//
//  Created by Romuald Szauer on 19/3/26.
//

import Foundation
import SwiftUI

@Observable
class GameViewModel<GameClock: Clock> where GameClock.Duration == Duration {
    private var bestTimeStore: BestTimeStore
    private var clock: GameClock

    private(set) var board: Chess.Board
    private var game: any Chess.Game.Interface
    
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
    
    var dismiss: DismissAction?
    
    init(
        bestTimeStore: BestTimeStore = .init(),
        clock: GameClock = .continuous,
        boardSize: Int,
        game: any Chess.Game.Interface
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
    
    func viewAppeared(dismiss: DismissAction) {
        self.dismiss = dismiss
        self.startGameIfNeeded()
    }
    
    func squareTapped(at index: Int) {
        guard !gameFinished else { return }
        
        let result = game.squareTapped(at: index, on: &board)
        gameStatus = result.gameStatus
        progress = result.progress

        if gameFinished {
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
            self.winOverlay = winOverlay
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
        startTime = clock.now
        finishTime = nil

        if let bestTime = bestTimeStore.bestTime(for: board.size) {
            self.bestTime = Duration.seconds(bestTime)
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
