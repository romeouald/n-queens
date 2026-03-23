//
//  BoardView.swift
//  NQueens
//
//  Created by Romuald Szauer on 19/3/26.
//

import SwiftUI

struct BoardView: View {
    let board: Chess.Board
    var onSquareTap: ((_ index: Int) -> Void)?
    
    init(board: Chess.Board) {
        self.board = board
    }
    
    func onSquareTap(_ callback: ((_ index: Int) -> Void)?) -> Self {
        var view = self
        view.onSquareTap = callback
        return view
    }
    
    var body: some View {
        GeometryReader { geometry in
            let sideLength = min(geometry.size.width, geometry.size.height)
            let squareSideLength = sideLength / Double(board.size)
            
            let fontSize = squareSideLength * 0.25
            let font = Font.system(size: fontSize, weight: .bold)
            let padding = squareSideLength * 0.05
            
            ForEach(0 ..< board.squares.count, id: \.self) { i in
                let row = board.row(for: i)
                let column = board.column(for: i)
                let isDark = row.isMultiple(of: 2) == column.isMultiple(of: 2)
                let color = isDark ? Chess.Color.dark : .light
                let piece = board.squares[i].piece
                
                ZStack {
                    Rectangle().fill(color.squareColor)
                    
                    // Row labels (number)
                    if column == 0 {
                        Text("\(row.formatted(.index))")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(padding)
                    }

                    // Column labels (aplha)
                    if row == 0 {
                        Text("\(column.formatted(.alpha))")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                            .padding(.trailing, padding)
                            .padding(.bottom, padding / 2)
                    }
                    
                    // Conflict color overlay
                    if board.squares[i].hasConflict {
                        Rectangle().fill(Color.overlayError)
                    }
                    
                    // Piece
                    if let piece {
                        Image(piece.image)
                            .resizable()
                    }
                }
                .foregroundStyle(color.labelColor)
                .frame(width: squareSideLength, height: squareSideLength)
                .offset(
                    x: CGFloat(column) * squareSideLength,
                    y: geometry.size.height - CGFloat(row + 1) * squareSideLength
                )
                .onTapGesture {
                    onSquareTap?(i)
                }
            }
            .font(font)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

private extension Chess.Color {
    var squareColor: Color {
        switch self {
        case .light: .greenLight
        case .dark: .greenDark
        }
    }
    
    var labelColor: Color {
        switch self {
        case .light: .greenDark
        case .dark: .greenLight
        }
    }
}

private extension Chess.Piece {
    var image: ImageResource {
        switch self.color {
        case .light:
            switch self.figure {
            case .queen: .queenLight
            }
        case .dark:
            switch self.figure {
            case .queen: .queenDark
            }
        }
    }
}


#Preview {
    NavigationStack {
        BoardView(
            board: .init(size: 8)
        )
    }
}
