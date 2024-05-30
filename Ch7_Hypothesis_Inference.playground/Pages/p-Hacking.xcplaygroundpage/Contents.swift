//: [Previous](@previous)

import Foundation
import Numerics

/// if you set out to find "significant" results, you can

func runExperiment() -> [Int] {
    /// Flips a fair coin 1,000 times, 1 = heads, 0 = tails
    (0..<1_000).map { _ in
        Float.random(in: 0..<1) < 0.5 ? 1 : 0
    }
}

func rejectFairness(experiment: [Int]) -> Bool {
    let numHeads = experiment.reduce(0, +)
    return (numHeads < 469 || numHeads > 531)
}

/// if you set out to find "significant" results, you can
let rejections = (0..<1_000).map { _ in
    rejectFairness(experiment: runExperiment())
}.filter { $0 }
print(rejections.count)


//: [Next](@next)
