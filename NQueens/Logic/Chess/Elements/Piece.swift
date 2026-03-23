//
//  Piece.swift
//  NQueens
//
//  Created by Romuald Szauer on 19/3/26.
//

extension Chess {
    struct Piece: Equatable, Hashable {
        let figure: Figure
        let color: Color
    }
}

extension Chess.Piece {
    enum Figure: Equatable, Hashable {
        case queen
    }
}
