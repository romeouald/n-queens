//
//  Integer+AlphaString.swift
//  NQueens
//
//  Created by Romuald Szauer on 20/3/26.
//

import Foundation

struct AlphaFormatStyle: FormatStyle {
    func format(_ value: Int) -> String {
        guard value >= 0 else { return "" }
        var number = value
        var chars: [Character] = []
        let startValue = Unicode.Scalar("a").value

        repeat {
            let remainder = UInt32(number % 26)
            if let scalar = Unicode.Scalar(startValue + remainder) {
                chars.append(Character(scalar))
            }
            number = (number / 26) - 1
        } while number >= 0
        
        return String(chars.reversed())
    }
}

extension FormatStyle where Self == AlphaFormatStyle {
    static var alpha: AlphaFormatStyle { .init() }
}
