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
        VStack {
            BoardView(board: viewModel.board)
                .onSquareTap { index in
                    viewModel.squareTapped(at: index)
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .tint(Color.greenDark)
    }
}

#Preview {
    NavigationStack {
        GameView(viewModel: .init(
            boardSize: 8,
            game: NQueens()
        ))
    }
}
