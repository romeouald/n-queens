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
                            Text(bestTime.formatted(
                                .time(pattern: .minuteSecond(
                                    padMinuteToLength: 2,
                                    fractionalSecondsLength: 1
                                ))
                            ))
                        } else {
                            Text("none")
                                .italic()
                        }
                    }
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
            case let .game(boardSize):
                GameView(viewModel: .init(boardSize: boardSize, game: NQueens()))
            }
        }
    }
}

#Preview {
    NavigationStack {
        ConfigurationView(viewModel: .init())
    }
    .background(Color.background)
}
