//
//  ConfigurationView.swift
//  NQueens
//
//  Created by Romuald Szauer on 18/3/26.
//

import SwiftUI

struct ConfigurationView: View {
    @State var viewModel: ConfigurationViewModel
    
    var body: some View {
        VStack {
            Text("N Queens")
                .font(.title.weight(.bold))

            Form {
                Section {
                    Picker("Board size", selection: $viewModel.boardSize) {
                        ForEach(4 ... 16, id: \.self) { i in
                            Text("\(i)x\(i)").tag(i)
                        }
                    }
                    .pickerStyle(.menu)
                } footer: {
                    HStack(spacing: 3) {
                        Text("Best time:")
                        
                        if let bestTime = viewModel.bestTime {
                            Text(bestTime.formatted(.gameTime))
                        } else {
                            Text("none")
                                .italic()
                        }
                    }
                }
                .listRowBackground(Color.overlayDark)

                Section {
                    Picker("Game", selection: $viewModel.game) {
                        ForEach(ConfigurationViewModel.Game.allCases) { game in
                            Text(game.title).tag(game)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .listRowBackground(Color.overlayDark)
                
                Section {
                    Button(action: { viewModel.startButtonTapped() }) {
                        Text("START GAME")
                            .font(.system(size: 16, weight: .heavy))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.background)
        .foregroundStyle(Color.white)
        .tint(Color.greenDark)
        .navigationDestination(item: $viewModel.destination) { destination in
            switch destination {
            case let .game(boardSize, game):
                GameView(viewModel: .init(boardSize: boardSize, game: game.engine))
            }
        }
    }
}

extension ConfigurationViewModel.Game {
    var title: String {
        switch self {
        case .nqueens: "N-Queens"
        case .nknights: "N-Knights"
        }
    }
}

#Preview {
    NavigationStack {
        ConfigurationView(viewModel: .init())
    }
    .background(Color.background)
}
