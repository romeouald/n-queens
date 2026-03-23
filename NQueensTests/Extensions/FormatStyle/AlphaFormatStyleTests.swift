//
//  FormatStyle+AlphaFormatStyleTests.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

@testable import NQueens
import Foundation
import Testing

@Suite("AlphaFormatStyle")
@MainActor
struct AlphaFormatStyleTests {

    let style = AlphaFormatStyle()

    // MARK: - Single letters (0–25)

    @Suite("single letters")
    @MainActor
    struct SingleLetters {
        let style = AlphaFormatStyle()

        @Test func zeroFormatsToA() {
            #expect(style.format(0) == "a")
        }

        @Test func oneFormatsToB() {
            #expect(style.format(1) == "b")
        }

        @Test func twentyFiveFormatsToZ() {
            #expect(style.format(25) == "z")
        }

        @Test(arguments: zip(0..<26, Array("abcdefghijklmnopqrstuvwxyz")))
        func allSingleLetters(value: Int, expected: Character) {
            #expect(style.format(value) == String(expected))
        }
    }

    // MARK: - Double letters (26–701)

    @Suite("double letters")
    @MainActor
    struct DoubleLetters {
        let style = AlphaFormatStyle()

        @Test func twentySixFormatsToAA() {
            #expect(style.format(26) == "aa")
        }

        @Test func twentySevenFormatsToAB() {
            #expect(style.format(27) == "ab")
        }

        @Test func fiftyOneFormatsToAZ() {
            #expect(style.format(51) == "az")
        }

        @Test func fiftyTwoFormatsToBa() {
            #expect(style.format(52) == "ba")
        }

        @Test func sevenHundredOneFormatsToZZ() {
            #expect(style.format(701) == "zz")
        }
    }

    // MARK: - Triple letters (702+)

    @Suite("triple letters")
    @MainActor
    struct TripleLetters {
        let style = AlphaFormatStyle()

        @Test func sevenHundredTwoFormatsToAAA() {
            #expect(style.format(702) == "aaa")
        }

        @Test func sevenHundredThreeFormatsToAAB() {
            #expect(style.format(703) == "aab")
        }
    }

    // MARK: - Negative values

    @Suite("negative values")
    @MainActor
    struct NegativeValues {
        let style = AlphaFormatStyle()

        @Test func negativeOneReturnsEmptyString() {
            #expect(style.format(-1) == "")
        }

        @Test func largeNegativeReturnsEmptyString() {
            #expect(style.format(-100) == "")
        }
    }

    // MARK: - Static accessor

    @Suite("static accessor")
    @MainActor
    struct StaticAccessor {
        @Test func alphaAccessorProducesCorrectResult() {
            #expect(0.formatted(.alpha) == "a")
            #expect(25.formatted(.alpha) == "z")
            #expect(26.formatted(.alpha) == "aa")
        }
    }
}
