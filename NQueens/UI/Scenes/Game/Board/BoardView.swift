//
//  BoardView.swift
//  NQueens
//
//  Created by Romuald Szauer on 19/3/26.
//

import SwiftUI

struct BoardView: View {
    @State var viewModel: BoardViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let sideLength = min(geometry.size.width, geometry.size.height)
            let squareSideLength = sideLength / Double(viewModel.board.size)
            
            ForEach(0 ..< viewModel.board.squares.count, id: \.self) { i in
                let row = i / viewModel.board.size
                let column = i % viewModel.board.size
                let isDark = row.isMultiple(of: 2) == column.isMultiple(of: 2)
                let color = isDark ? Color.greenDark : Color.greenLight
                
                Rectangle()
                    .fill(color)
                    .frame(width: squareSideLength, height: squareSideLength)
                    .offset(
                        x: CGFloat(column) * squareSideLength,
                        y: geometry.size.height - CGFloat(row + 1) * squareSideLength
                    )
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    NavigationStack {
        BoardView(viewModel: .init(board: .init(size: 8)))
    }
}
