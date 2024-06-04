//: [Previous](@previous)

import Foundation
import Numerics

// need to move to doubles here
func B(alpha: Double, beta: Double) -> Double {
    /// a normalizing constant so that the total probability is 1
    return (Double.gamma(alpha) * Double.gamma(beta)) / Double.gamma(alpha + beta)
}


func betaPDF(x: Double, alpha: Double, beta: Double) -> Double {
    if x < 0 || x > 1 {
        return 0
    }
    
    return (pow(x, (alpha - 1)) * pow((1 - x), (beta - 1))) / B(alpha: alpha, beta: beta)
}

for x in stride(from: 0.0, to: 1.0, by: 0.1) {
    let o = betaPDF(x: x, alpha: 4, beta: 16)
    print(o)
}

for x in stride(from: 0.0, to: 1.0, by: 0.1) {
    let o = betaPDF(x: x, alpha: 16, beta: 4)
    print(o)
}

//: [Next](@next)
