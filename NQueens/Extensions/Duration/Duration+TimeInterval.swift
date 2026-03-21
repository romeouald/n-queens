//
//  Duration+TimeInterval.swift
//  NQueens
//
//  Created by Romuald Szauer on 21/3/26.
//

import Foundation

extension Duration {
    var timeInterval: TimeInterval {
        Double(components.seconds) + Double(components.attoseconds) * 1e-18
    }
}
