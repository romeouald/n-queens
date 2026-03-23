//
//  TestClock.swift
//  NQueens
//
//  Created by Romuald Szauer on 23/3/26.
//

import Foundation

final class TestClock: Clock, @unchecked Sendable {
    let minimumResolution: Duration = .milliseconds(1)
    
    typealias Duration = Swift.Duration

    struct Instant: InstantProtocol {
        var offset: Duration = .zero
        func advanced(by duration: Duration) -> Instant {
            Instant(offset: offset + duration)
        }
        func duration(to other: Instant) -> Duration {
            other.offset - offset
        }
        static func < (lhs: Instant, rhs: Instant) -> Bool {
            lhs.offset < rhs.offset
        }
    }

    private(set) var now = Instant()

    func advance(by duration: Duration) {
        now = now.advanced(by: duration)
    }

    func sleep(until deadline: Instant, tolerance: Duration?) async throws {
        now = deadline
    }
}
