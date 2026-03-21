//
//  GameView.swift
//  NQueens
//
//  Created by Romuald Szauer on 19/3/26.
//

import SwiftUI

struct GameView: View {
    @State var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            timerView
            BoardView(board: viewModel.board)
                .onSquareTap { index in
                    viewModel.squareTapped(at: index)
                }
            
        }
        .onAppear { viewModel.startGame() }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .tint(Color.greenDark)
    }
    
    private var timerView: some View {
        HStack(spacing: 8) {
            Image(systemName: "clock")
                .resizable()
                .frame(width: 15, height: 15)
                .fontWeight(.black)
            TimelineView(.animation(minimumInterval: 0.05, paused: viewModel.gameFinished)) { _ in
                Text(viewModel.elapsedTime.formatted(
                    .time(pattern: .minuteSecond(
                        padMinuteToLength: 2,
                        fractionalSecondsLength: 1
                    ))
                ))
            }
        }
        .foregroundStyle(.white)
        .font(Font.system(size: 16, weight: .bold))
        .monospacedDigit()
        .padding(10)
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

#Preview {
    NavigationStack {
        GameView(viewModel: .init(
            boardSize: 4,
            game: NQueens()
        ))
    }
}
