import Cocoa
import Numerics

/// let's try using these as functions instead of methods on x to see how they feel in comparison
func normalCdf(x: Float, mu: Float = 0, sigma: Float = 1) -> Float {
    return (1 + Float.erf((x - mu) / Float(2).squareRoot() / sigma)) / 2
}

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


func normalApproximationToBinomial(n: Float, p: Float) -> (Float, Float) {
    let mu = n * p
    let sigma = sqrt(p * (1 - p) * n)
    
    return (mu, sigma)
}

func normalProbabilityBelow(_ hi: Float, mu: Float = 0, sigma: Float = 1) -> Float {
    /// The probability that an N(mu, sigma) is less than x
    normalCdf(x: hi, mu: mu, sigma: sigma)
}

func normalProbabilityAbove(_ lo: Float, mu: Float = 0, sigma: Float = 1) -> Float {
    /// The probability that an N(mu, sigma) is greater than lo
    1 - normalCdf(x: lo, mu: mu, sigma: sigma)
}

func normalProbabilityBetween(_ lo: Float, and hi: Float, mu: Float = 0, sigma: Float = 1) -> Float {
    /// The probability that an N(mu, sigma) is between lo and hi
    return normalCdf(x: hi, mu: mu, sigma: sigma) - normalCdf(x: lo, mu: mu, sigma: sigma)
}

func normalProbabilityOutside(_ lo: Float, and hi: Float, mu: Float = 0, sigma: Float = 1) -> Float {
    return 1 - normalProbabilityBetween(lo, and: hi, mu: mu, sigma: sigma)
}

func normalUpperBound(p: Float, mu: Float = 0, sigma: Float = 1) -> Float {
    /// Returns the z for which P(Z <= z) = p
    return inverseNormalCdf(x: p, mu: mu, sigma: sigma)
}

func normalLowerBound(p: Float, mu: Float = 0, sigma: Float = 1) -> Float {
    /// Returns the z for which P(Z  >= z) = p
    return inverseNormalCdf(x: 1 - p, mu: mu, sigma: sigma)
}

func normalTwoSidedBounds(p: Float, mu: Float = 0, sigma: Float = 1) -> (Float, Float) {
    /// Returns the symmetric (around the mean) bounds that contains the given probability.
    let tailP = (1 - p) / 2
    
    let upperBound = normalLowerBound(p: tailP, mu: mu, sigma: sigma)
    let lowerBound = normalUpperBound(p: tailP, mu: mu, sigma: sigma)
    
    return (lowerBound, upperBound)
}

/// significance
let (mu0, sigma0) = normalApproximationToBinomial(n: 1_000, p: 0.5)
print("mean is \(mu0) and sigma is \(sigma0) with 1k binomials with p 0.5")
let (lowerBound, upperBound) = normalTwoSidedBounds(p: 0.95, mu: mu0, sigma: sigma0)
print("bounds: (\(lowerBound), \(upperBound))")

/// test poewr
let (lo, hi) = normalTwoSidedBounds(p: 0.95, mu: mu0, sigma: sigma0)
let (mu1, sigma1) = normalApproximationToBinomial(n: 1_000, p: 0.55)
let type2Probability = normalProbabilityBetween(lo, and: hi, mu: mu1, sigma: sigma1)
let power = 1 - type2Probability
print("power is \(power)")

/// one sided test
let hi2 = normalUpperBound(p: 0.95, mu: mu0, sigma: sigma0)
print("hi for one sided test is \(hi2)")
let type2Probability2 = normalProbabilityBelow(hi2, mu: mu1, sigma: sigma1)
let oneSidedPower = 1 - type2Probability2
print("one sided test power is \(oneSidedPower)")

