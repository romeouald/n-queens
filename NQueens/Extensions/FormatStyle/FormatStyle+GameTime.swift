//
//  FormatStyle+GameTime.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

import Foundation

extension FormatStyle where Self == Duration.TimeFormatStyle {
    static var gameTime: Duration.TimeFormatStyle {
        .time(pattern: .minuteSecond(
            padMinuteToLength: 2,
            fractionalSecondsLength: 1
        ))
    }
}
