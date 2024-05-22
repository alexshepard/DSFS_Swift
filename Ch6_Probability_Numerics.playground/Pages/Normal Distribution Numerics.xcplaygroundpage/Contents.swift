//: [Previous](@previous)

import Foundation
import Numerics
import Cocoa
import SwiftUI
import Charts
import PlaygroundSupport

extension Real {
    func normalPdf(mu: Self = 0, sigma: Self = 1) -> Self {
        let exponent = -((self - mu) * (self - mu)) / (2 * sigma * sigma)
        let numer = Self.exp(exponent)

        let sqrtTwoPiSigma = (Self.pi * 2).squareRoot() * sigma
        return numer / sqrtTwoPiSigma
    }
}

let x: Float = 0.3
print(x.normalPdf())

/// # let's chart some variants of the normal distribution
struct Point: Identifiable {
    var id: UUID = UUID()

    var x: Double
    var y: Double
    var category: String
}

let categories = [
    (mu: 0.0, sigma: 1.0, label: "Mu: 0, Sigma: 1"),
    (mu: 0.0, sigma: 2.0, label: "Mu: 0, Sigma: 2"),
    (mu: 0.0, sigma: 0.5, label: "Mu: 0, Sigma: 0.5"),
    (mu: -1.0, sigma: 1.0, label: "Mu: -1, Sigma: 1")
]

let xs = stride(from: -5, to: 5, by: 0.1)
let points = xs.flatMap { x -> [Point] in
    return categories.map { category in
        Point(
            x: Double(x),
            y: Double(x).normalPdf(mu: category.mu, sigma: category.sigma),
            category: category.label
        )
    }
}

struct ChartView: View {
    var body: some View {
        VStack {
            Text("Normal Distribution")
            Chart(points) {
                LineMark(
                    x: .value("x", $0.x),
                    y: .value("y", $0.y)
                )
                .foregroundStyle(by: .value("Category", $0.category))
                // smoothing between points
                .interpolationMethod(.catmullRom)
            }
            .chartXScale(domain: [-5, 5])
            .chartYScale(domain: [0, 1])
            .frame(width: 500, height: 300)
        }
        .padding(.top, 10)
    }
}


let view = ChartView()
PlaygroundPage.current.setLiveView(view)


//: [Next](@next)
