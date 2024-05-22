//: [Previous](@previous)

var greeting = "Hello, playground"
print(greeting)

import Foundation

extension FloatingPoint {
    func normalPdf(mu: Self = Self(0), sigma: Self = Self(1)) -> Self {
        let exponent = -((self - mu) * (self - mu)) / (2 * sigma * sigma)
        let numer = 
        let numer = exp(exponent)

        let sqrtTwoPi = (Self.pi * 2).squareRoot()
        let denom = sqrtTwoPi * sigma

        return numer / denom
    }
}

let x: Float = 0.3
print(x.normalPdf())

print(sigmoid(0.5))

//: [Next](@next)
