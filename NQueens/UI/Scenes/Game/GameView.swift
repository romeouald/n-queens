//
//  GameView.swift
//  NQueens
//
//  Created by Romuald Szauer on 19/3/26.
//

import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    
    typealias ViewModel = GameViewModel<ContinuousClock>
    @State var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            timeBar
            BoardView(board: viewModel.board)
                .onSquareTap { index in
                    viewModel.squareTapped(at: index)
                }
            progressBar
                .padding(.horizontal, 24)
            
            Spacer()
            
            buttonBar
            
        }
        .onAppear {
            viewModel.viewAppeared(dismiss: { dismiss() })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .alert(item: $viewModel.alert) { item in
            alert(item)
        }
        .overlay {
            if let winOverlay = viewModel.winOverlay {
                WinOverlay(style: winOverlay)
                    .onDismiss(viewModel.winOverlayDismissed)
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private var timeBar: some View {
        HStack(spacing: 24) {
            if let bestTime = viewModel.bestTime {
                StatCell(icon: Image(systemName: "trophy")) {
                    Text(bestTime.formatted(.gameTime))
                }
            }
            
            StatCell(icon: Image(systemName: "clock")) {
                TimelineView(.animation(minimumInterval: 0.05, paused: viewModel.gameFinished)) { _ in
                    Text(viewModel.elapsedTime.formatted(.gameTime))
                }
            }
        }
    }
    
    private var progressBar: some View {
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
    
    private var buttonBar: some View {
        HStack(spacing: 24) {
            Button(action: { viewModel.backButtonTapped() }) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(8)
                    .frame(maxWidth: .infinity)
            }
            Button(action: { viewModel.resetButtonTapped() }) {
                Image(systemName: "arrow.counterclockwise")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(8)
                    .frame(maxWidth: .infinity)
            }
        }
        .bold()
        .buttonStyle(.borderless)
        .tint(.gray)
        .frame(height: 44)
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .background(Color.overlayDark)
        .clipped()
    }
    
    private func alert(_ alert: ViewModel.Alert) -> Alert {
        switch alert {
        case .resetPrompt:
            Alert(
                title: Text("Are you sure you want reset the game?"),
                message: Text("All current progress will be lost."),
                primaryButton: .destructive(Text("Reset")) {
                    viewModel.resetPromptConfirmButtonTapped()
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        case .leavePrompt:
            Alert(
                title: Text("Are you sure you want to exit the game?"),
                message: Text("All current progress will be lost."),
                primaryButton: .destructive(Text("Leave")) {
                    viewModel.leavePromptConfimButtonTapped()
                },
                secondaryButton: .cancel(Text("Stay"))
            )
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
