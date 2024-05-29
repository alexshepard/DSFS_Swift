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

let (m, s) = normalApproximationToBinomial(n: 1_000, p: 0.5)
print(m, s)

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

func twoSidedBounds(p: Float, mu: Float = 0, sigma: Float = 1) -> (Float, Float) {
    /// Returns the symmetric (around the mean) bounds that contains the given probability.
    let tailP = (1 - p) / 2
    
    let upperBound = normalLowerBound(p: tailP, mu, sigma)
    let lowerBound = normalUpperBound(p: tailP, mu, sigma)
    
    return (lowerBound, upperBound)
}
