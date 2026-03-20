//
//  ConfigurationViewModel.swift
//  NQueens
//
//  Created by Romuald Szauer on 18/3/26.
//

import Foundation

@Observable
class ConfigurationViewModel {
    var boardSize: Int = 4
    
    enum Destination: Hashable {
        case game(boardSize: Int)
    }
    var destination: Destination?
    
    func startButtonTapped() {
        destination = .game(boardSize: boardSize)
    }
}
