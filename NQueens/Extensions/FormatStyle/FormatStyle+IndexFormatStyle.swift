//
//  IndexFormatStyle.swift
//  NQueens
//
//  Created by Romuald Szauer on 20/3/26.
//

import Foundation

struct IndexFormatStyle: FormatStyle {
    func format(_ value: Int) -> String {
        "\(value + 1)"
    }
}

extension FormatStyle where Self == IndexFormatStyle {
    static var index: IndexFormatStyle { .init() }
}
