//: [Previous](@previous)

import Foundation
import Numerics

/// from a previous section
func normalApproximationToBinomial(n: Float, p: Float) -> (Float, Float) {
    let mu = n * p
    let sigma = sqrt(p * (1 - p) * n)
    
    return (mu, sigma)
}

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

/// from a previous section
func inverseNormalCdf(x: Float, mu: Float = 0, sigma: Float = 1, tolerance: Float = 0.00001) -> Float {
    if mu != 0 || sigma != 1 {
        return mu + sigma * inverseNormalCdf(x: x, mu: 0, sigma: 1, tolerance: tolerance)
    }
    
    var lowZ: Float = -10
    var hiZ: Float = 10
    var midZ: Float = 0
    
    while (hiZ - lowZ) > tolerance {
        midZ = (lowZ + hiZ) / 2
        let midP = normalCdf(x: midZ)
        if midP < x {
            lowZ = midZ
        } else {
            hiZ = midZ
        }
    }
    
    return midZ
}

/// from previous section
func normalUpperBound(p: Float, mu: Float = 0, sigma: Float = 1) -> Float {
    /// Returns the z for which P(Z <= z) = p
    return inverseNormalCdf(x: p, mu: mu, sigma: sigma)
}

/// from previous section
func normalLowerBound(p: Float, mu: Float = 0, sigma: Float = 1) -> Float {
    /// Returns the z for which P(Z  >= z) = p
    return inverseNormalCdf(x: 1 - p, mu: mu, sigma: sigma)
}

/// from previous section
func normalTwoSidedBounds(p: Float, mu: Float = 0, sigma: Float = 1) -> (Float, Float) {
    /// Returns the symmetric (around the mean) bounds that contains the given probability.
    let tailP = (1 - p) / 2
    
    let upperBound = normalLowerBound(p: tailP, mu: mu, sigma: sigma)
    let lowerBound = normalUpperBound(p: tailP, mu: mu, sigma: sigma)
    
    return (lowerBound, upperBound)
}

let (mu0, sigma0) = normalApproximationToBinomial(n: 1_000, p: 0.5)

// fair coin is in this confidence interval
let pHat: Float = 525.0 / 1000.0
let mu = pHat
let sigma = sqrt(pHat * (1 - pHat) / 1_000)
print(mu, sigma)
let confidenceInterval95p = normalTwoSidedBounds(p: 0.95, mu: mu, sigma: sigma)
print(confidenceInterval95p)

// fair coin is not in this confidence interval
let pHat2: Float = 540.0 / 1000.0
let mu2 = pHat2
let sigma2 = sqrt(pHat2 * (1 - pHat2) / 1_000)
let confidenceInterval95p2 = normalTwoSidedBounds(p: 0.95, mu: mu2, sigma: sigma2)
print(confidenceInterval95p2)

//: [Next](@next)
