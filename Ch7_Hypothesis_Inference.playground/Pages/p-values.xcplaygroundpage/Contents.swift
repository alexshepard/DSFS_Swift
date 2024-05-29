//: [Previous](@previous)

import Foundation
import Numerics

/// from previous section
func normalCdf(x: Float, mu: Float = 0, sigma: Float = 1) -> Float {
    return (1 + Float.erf((x - mu) / Float(2).squareRoot() / sigma)) / 2
}
func normalProbabilityBelow(_ hi: Float, mu: Float = 0, sigma: Float = 1) -> Float {
/// The probability that an N(mu, sigma) is less than x
normalCdf(x: hi, mu: mu, sigma: sigma)
}
func normalProbabilityAbove(_ lo: Float, mu: Float = 0, sigma: Float = 1) -> Float {
/// The probability that an N(mu, sigma) is greater than lo
1 - normalCdf(x: lo, mu: mu, sigma: sigma)
}
func normalApproximationToBinomial(n: Float, p: Float) -> (Float, Float) {
    let mu = n * p
    let sigma = sqrt(p * (1 - p) * n)
    
    return (mu, sigma)
}


/// p-values

func twoSidedPValue(x: Float, mu: Float = 0, sigma: Float = 1) -> Float {
    /// How likely are we to see a value at least as extreme as x (in either direction)
    /// if our values are from an N(mu, sigma)?
    if x >= mu {
        // the tail is everything greater than x
        return 2 * normalProbabilityAbove(x, mu: mu, sigma: sigma)
    } else {
        // the tail is everything less than x
        return 2 * normalProbabilityBelow(x, mu: mu, sigma: sigma)
    }
}

let (mu0, sigma0) = normalApproximationToBinomial(n: 1_000, p: 0.5)

// continuity correction
let p = twoSidedPValue(x: 529.5, mu: mu0, sigma: sigma0)
print(p)

/// let's simulate this

var extremeValueCount = 0
for _ in 0..<1_000 {
    let r = 0..<1_000
    let numHeads = (0..<1_000)
        .map { _ in Float.random(in: 0..<1) < 0.5 ? 1 : 0 }
        .reduce(0, +)
    if numHeads >= 530 || numHeads <= 470 {
        extremeValueCount += 1
    }
}
print(Double(extremeValueCount) / 1_000)

//: [Next](@next)
