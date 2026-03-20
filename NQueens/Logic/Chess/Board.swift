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
            if size <= 0 { assertionFailure("Board size must be greater than 0") }
            
            self.size = size
            self.squares = Array(repeating: Square(), count: size * size)
        }
        
        func row(for index: Int) -> Int {
            index / size
        }
        
        func column(for index: Int) -> Int {
            index % size
        }
    }
}
