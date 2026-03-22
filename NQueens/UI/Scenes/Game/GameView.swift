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
            progressView
                .padding(.horizontal, 24)
            
        }
        .onAppear { viewModel.startGame() }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .tint(Color.greenDark)
    }
    
    private var timerView: some View {
        HStack(spacing: 24) {
            if let bestTime = viewModel.bestTime {
                StatCell(icon: Image(systemName: "trophy")) {
                    Text(bestTime.formatted(
                        .time(pattern: .minuteSecond(
                            padMinuteToLength: 2,
                            fractionalSecondsLength: 1
                        ))
                    ))
                }
            }
            
            StatCell(icon: Image(systemName: "clock")) {
                TimelineView(.animation(minimumInterval: 0.05, paused: viewModel.gameFinished)) { _ in
                    Text(viewModel.elapsedTime.formatted(
                        .time(pattern: .minuteSecond(
                            padMinuteToLength: 2,
                            fractionalSecondsLength: 1
                        ))
                    ))
                }
            }
        }
    }
    
    private var progressView: some View {
        HStack(alignment: .center, spacing: 12) {
            GeometryReader { geometry in
                Capsule()
                    .fill(.black)
                Capsule()
                    .fill(.greenDark)
                    .animation(.default, value: viewModel.gameFinished)
                    .overlay(Capsule().fill(.overlayError.opacity(viewModel.hasError ? 1 : 0)))
                    .animation(.default, value: viewModel.hasError)
                    .frame(width: geometry.size.width * viewModel.progress.percentage)
                    .animation(.default, value: viewModel.progress.percentage)
            }
            .frame(height: 12)
            
            Text("\(viewModel.progress.step) / \(viewModel.progress.total)")
                .foregroundStyle(.white)
                .font(Font.system(size: 16, weight: .black))
                .monospacedDigit()
        }
    }
}

private extension GameView {
    struct StatCell<Content: View>: View {
        let icon: Image
        let content: () -> Content
        
        var body: some View {
            HStack(spacing: 8) {
                icon
                    .resizable()
                    .frame(width: 15, height: 15)
                    .fontWeight(.black)
                content()
            }
            .foregroundStyle(.white)
            .font(Font.system(size: 16, weight: .bold))
            .monospacedDigit()
            .padding(10)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

#Preview {
    NavigationStack {
        GameView(viewModel: .preview)
    }
}
