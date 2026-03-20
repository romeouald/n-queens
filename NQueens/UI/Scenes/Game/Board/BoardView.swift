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
            
            let fontSize = squareSideLength * 0.25
            let font = Font.system(size: fontSize, weight: .bold)
            let padding = squareSideLength * 0.05
            
            ForEach(0 ..< viewModel.board.squares.count, id: \.self) { i in
                let row = viewModel.board.row(for: i)
                let column = viewModel.board.column(for: i)
                let isDark = row.isMultiple(of: 2) == column.isMultiple(of: 2)
                let color = isDark ? Chess.Color.dark : .light
                
                square(
                    color: color,
                    piece: viewModel.board.squares[i].piece,
                    font: font,
                    padding: padding,
                    rowLabel: column == 0 ? row.formatted(.index) : nil,
                    columnLabel: row == 0 ? column.formatted(.alpha) : nil
                )
                .frame(width: squareSideLength, height: squareSideLength)
                .offset(
                    x: CGFloat(column) * squareSideLength,
                    y: geometry.size.height - CGFloat(row + 1) * squareSideLength
                )
                .onTapGesture {
                    viewModel.squareTapped(at: i)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private func square(
        color: Chess.Color,
        piece: Chess.Piece?,
        font: Font,
        padding: CGFloat,
        rowLabel: String?,
        columnLabel: String?
    ) -> some View {
        ZStack {
            Rectangle().fill(color.squareColor)
            
            if let rowLabel {
                Text("\(rowLabel)")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(padding)
            }

            if let columnLabel {
                Text("\(columnLabel)")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(.trailing, padding)
                    .padding(.bottom, padding / 2)
            }
            
            if let piece {
                Image(piece.image)
                    .resizable()
            }
        }
        .font(font)
        .foregroundStyle(color.labelColor)
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
            switch self.type {
            case .queen: .queenLight
            }
        case .dark:
            switch self.type {
            case .queen: .queenDark
            }
        }
    }
}


#Preview {
    NavigationStack {
        BoardView(viewModel: .init(
            board: .init(size: 8),
            game: NQueens()
        ))
    }
}
