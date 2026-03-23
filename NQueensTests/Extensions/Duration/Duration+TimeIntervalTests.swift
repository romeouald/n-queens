//
//  Duration+TimeIntervalTests.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

@testable import NQueens
import Testing
import Foundation

@Suite("Duration.timeInterval")
@MainActor
struct DurationTimeIntervalTests {

    // MARK: - Whole seconds

    @Suite("whole seconds")
    @MainActor
    struct WholeSeconds {
        @Test func zeroSecondsIsZero() {
            #expect(Duration.seconds(0).timeInterval == 0.0)
        }

        @Test func oneSecond() {
            #expect(Duration.seconds(1).timeInterval == 1.0)
        }

        @Test func oneHundredSeconds() {
            #expect(Duration.seconds(100).timeInterval == 100.0)
        }

        @Test func negativeOneSecond() {
            #expect(Duration.seconds(-1).timeInterval == -1.0)
        }
    }

    // MARK: - Fractional seconds

    @Suite("fractional seconds")
    @MainActor
    struct FractionalSeconds {
        @Test func halfSecond() {
            #expect(Duration.milliseconds(500).timeInterval == 0.5)
        }

        @Test func oneMillisecond() {
            #expect(abs(Duration.milliseconds(1).timeInterval - 0.001) < 1e-9)
        }

        @Test func oneMicrosecond() {
            #expect(abs(Duration.microseconds(1).timeInterval - 0.000_001) < 1e-12)
        }

        @Test func oneNanosecond() {
            #expect(abs(Duration.nanoseconds(1).timeInterval - 0.000_000_001) < 1e-15)
        }
    }

    // MARK: - Combined seconds and attoseconds

    @Suite("combined seconds and attoseconds")
    @MainActor
    struct Combined {
        @Test func oneSecondAndHalf() {
            #expect(abs(Duration.milliseconds(1500).timeInterval - 1.5) < 1e-9)
        }

        @Test func negativeFractional() {
            #expect(Duration.milliseconds(-500).timeInterval == -0.5)
        }
    }

    // MARK: - Precision

    @Suite("precision")
    @MainActor
    struct Precision {
        // TimeInterval (Double) has ~15-16 significant digits of precision.
        // Sub-nanosecond values stored in attoseconds will lose precision
        // when converted — this suite documents where that boundary lies.

        @Test func attosecondPrecisionIsLostInDouble() {
            // 1 attosecond = 1e-18s, which is below Double precision (~1e-16 at 1.0)
            let duration = Duration(secondsComponent: 1, attosecondsComponent: 1)
            // The attosecond contribution is too small to affect the Double representation
            #expect(duration.timeInterval == 1.0)
        }

        @Test func nanosecondPrecisionIsPreservedAtZeroSeconds() {
            #expect(abs(Duration.nanoseconds(1).timeInterval - 1e-9) < 1e-15)
        }
    }
}
