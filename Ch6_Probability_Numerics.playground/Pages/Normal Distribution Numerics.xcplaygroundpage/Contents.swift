//: [Previous](@previous)

import Foundation
import Numerics
import Cocoa
import SwiftUI
import Charts
import PlaygroundSupport

extension Real where Self: BinaryFloatingPoint {
    func normalPdf(mean mu: Self = 0, standardDeviation sigma: Self = 1) -> Self {
        let exponent = Self.exp(-((self - mu) * (self - mu)) / (2 * sigma * sigma))
        return Self.exp(-((self - mu) * (self - mu)) / (2 * sigma * sigma)) / ((Self.pi * 2).squareRoot() * sigma)
    }
    
    func normalCdf(mean mu: Self = 0, standardDeviation sigma: Self = 1) -> Self {
        return (1 + Self.erf((self - mu) / Self(2).squareRoot() / sigma)) / 2
    }

    func inverseNormalCdf(mean mu: Self = 0, standardDeviation sigma: Self = 1, tolerance: Self = 0.00001) -> Self {
        if mu != 0 || sigma != 1 {
            return mu + sigma * self.inverseNormalCdf(mean: 0, standardDeviation: 1, tolerance: tolerance)
        }
        
        // normal CDF of -10 is nearly zero, of 10 is nearly 1
        var lowZ: Self = -10
        var hiZ: Self = 10
        var midZ: Self = 0
        
        while (hiZ - lowZ) > tolerance {
            midZ = (lowZ + hiZ) / 2
            let midP = midZ.normalCdf(mean: 0, standardDeviation: 1)
            if midP < self {
                lowZ = midZ
            } else {
                hiZ = midZ
            }
        }
        
        return midZ
    }
}

let x: Double = 0.5
print(x.normalPdf())
print(x.normalCdf())
print(x.inverseNormalCdf(tolerance: 0.00001))
print(x.normalCdf().inverseNormalCdf(tolerance: 0.00001))


/// # let's chart some variants of the normal distribution
struct Point: Identifiable {
    var id: UUID = UUID()

    var x: Double
    var pdf: Double
    var cdf: Double
    var category: String
}

let categories = [
    (mean: 0.0,  standardDeviation: 1.0, label: "Mean: 0, Standard Deviation: 1"),
    (mean: 0.0,  standardDeviation: 2.0, label: "Mean: 0, Standard Deviation: 2"),
    (mean: 0.0,  standardDeviation: 0.5, label: "Mean: 0, Standard Deviation: 0.5"),
    (mean: -1.0, standardDeviation: 1.0, label: "Mean: -1, Standard Deviation: 1")
]

let xs = stride(from: -5, to: 5, by: 0.1)
let points = xs.flatMap { x -> [Point] in
    return categories.map { category in
        Point(
            x: Double(x),
            pdf: Double(x).normalPdf(mean: category.mean, standardDeviation: category.standardDeviation),
            cdf: Double(x).normalCdf(mean: category.mean, standardDeviation: category.standardDeviation),
            category: category.label
        )
    }
}


struct ChartView: View {
    @State private var fn = "cdf"
    private var fns = ["pdf", "cdf"]
    
    var body: some View {
        VStack {
            Text("Normal Distribution")
            Picker("Function", selection: $fn) {
                ForEach(fns, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.inline)
            
            Chart(points) {
                LineMark(
                    x: .value("x", $0.x),
                    y: .value("y", fn == "cdf" ? $0.cdf : $0.pdf)
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
