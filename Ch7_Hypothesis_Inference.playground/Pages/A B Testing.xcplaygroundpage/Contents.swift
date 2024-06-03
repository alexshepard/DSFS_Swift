//: [Previous](@previous)

import Foundation
import Numerics

/// from a previous section
func normalCdf(x: Float, mu: Float = 0, sigma: Float = 1) -> Float {
    return (1 + Float.erf((x - mu) / Float(2).squareRoot() / sigma)) / 2
}

/// from a previous section
func normalProbabilityBelow(_ hi: Float, mu: Float = 0, sigma: Float = 1) -> Float {
    /// The probability that an N(mu, sigma) is less than x
    normalCdf(x: hi, mu: mu, sigma: sigma)
}

/// from a previous section
func normalProbabilityAbove(_ lo: Float, mu: Float = 0, sigma: Float = 1) -> Float {
    /// The probability that an N(mu, sigma) is greater than lo
    1 - normalCdf(x: lo, mu: mu, sigma: sigma)
}

/// from a previous section
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


func estimatedParameters(N: Int, n: Int) -> (Float, Float) {
    // approximately a normal random variable
    let p = Float(n) / Float(N)
    let sigma = sqrt(p * (1 - p) / Float(N))
    return (p, sigma)
}

// 50 people see an ad, 5 people click on it
let (mu, sigma) = estimatedParameters(N: 50, n: 5)
print(mu, sigma)

func aBTestStatistic(NA: Int, nA: Int, NB: Int, nB: Int) -> Float {
    // test the null hypothesis that pa and pb are the same
    let (pA, sigmaA) = estimatedParameters(N: NA, n: nA)
    let (pB, sigmaB) = estimatedParameters(N: NB, n: nB)
    
    return (pB - pA) / sqrt(pow(sigmaA, 2) + pow(sigmaB, 2))
}

// decent chance (25%) two ads are equally effective
let z = aBTestStatistic(NA: 1_000, nA: 200, NB: 1_000, nB: 180)
print(z)
let probZ = twoSidedPValue(x: z)
print(probZ)

// highly unlikely (.3%) these two ads are equally effective
let z2 = aBTestStatistic(NA: 1_000, nA: 200, NB: 1_000, nB: 150)
print(z2)
let probZ2 = twoSidedPValue(x: z2)
print(probZ2)



//: [Next](@next)
