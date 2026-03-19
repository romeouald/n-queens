//
//  ConfigurationViewModel.swift
//  NQueens
//
//  Created by Romuald Szauer on 18/3/26.
//

import Foundation

struct ConfigurationViewModel: Equatable, Hashable {
    var boardSize: Int = 4
    
    enum Destination: Equatable, Hashable {
        case game(GameViewModel)
    }
    var destination: Destination?
    
    mutating func startButtonTapped() {
        destination = .game(.init())
    }
}
