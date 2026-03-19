//
//  Board.swift
//  NQueens
//
//  Created by Romuald Szauer on 19/3/26.
//

extension Chess {
    struct Board: Equatable, Hashable {
        let size: Int
        let squares: [Square]
        
        init(size: Int) {
            self.size = size
            self.squares = Array(repeating: Square(), count: size * size)
        }
    }
}
