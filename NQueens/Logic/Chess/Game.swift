//
//  Game.swift
//  NQueens
//
//  Created by Romuald Szauer on 20/3/26.
//

extension Chess {
    protocol Game {
        func squareTapped(at index: Int, on board: Board)
    }
}
