//
//  Piece.swift
//  NQueens
//
//  Created by Romuald Szauer on 19/3/26.
//

extension Chess {
    struct Piece: Equatable, Hashable {
        let type: `Type`
        let color: Color
    }
}

extension Chess.Piece {
    enum `Type`: Equatable, Hashable {
        case queen
    }
}
