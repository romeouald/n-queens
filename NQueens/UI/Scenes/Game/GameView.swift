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
            BoardView(viewModel: viewModel.board)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .tint(Color.greenDark)
    }
}

#Preview {
    NavigationStack {
        GameView(viewModel: .init(boardSize: 8))
    }
}
