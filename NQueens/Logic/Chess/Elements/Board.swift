//
//  Board.swift
//  NQueens
//
//  Created by Romuald Szauer on 19/3/26.
//

extension Chess {
    struct Board: Equatable, Hashable {
        let size: Int
        private(set) var squares: [Square]
        
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
        
        mutating func setPiece(_ piece: Piece, at index: Int) {
            squares[index].piece = piece
        }

        mutating func removePiece(at index: Int) {
            squares[index].piece = nil
        }
        
        mutating func setConflicts(at indices: Set<Int>, merge: Bool = false) {
            if !merge {
                for i in 0 ..< squares.count { squares[i].hasConflict = false }
            }
            
            indices.forEach { squares[$0].hasConflict = true }
        }
        
        mutating func reset() {
            for i in 0 ..< squares.count {
                squares[i].piece = nil
                squares[i].hasConflict = false
            }
        }
    }
}
