//: [Previous](@previous)

import Cocoa
import Numerics
import SwiftUI
import Charts
import PlaygroundSupport

extension Array where Element: Hashable {
    // this will come in handy a few times
    // this makes a counter out of a dict
    func counted() -> [Element: Int] {
        var counts = [Element: Int]()
        self.forEach { counts[$0, default: 0] += 1 }
        return counts
    }
}

extension Real where Self: BinaryFloatingPoint, Self.RawSignificand: FixedWidthInteger {
    func bernoulliTrial() -> Int {
        let r = Self.random(in: 0..<1)
        return r < self ? 1 : 0
    }
    
    func binomial(trials: Int) -> Int {
        (0..<trials).reduce(0) { result, _ in
            result + self.bernoulliTrial()
        }
    }
    
    func normalCdf(mean mu: Self = 0, standardDeviation sigma: Self = 1) -> Self {
        return (1 + Self.erf((self - mu) / Self(2).squareRoot() / sigma)) / 2
    }

}


let x = 0.3
x.bernoulliTrial()
x.binomial(trials: 500)

(0.9).binomial(trials: 300)

let numSamples = 1000
let p = 0.75
let numTrials = 100

var data = [Int]()
for _ in 0..<numSamples {
    data.append(p.binomial(trials: numTrials))
}

var histogram = data.counted()

struct HistogramBin: Identifiable {
    var id: UUID = UUID()
    
    var bin: Int
    var count: Float
}

var histogramBins = stride(from: 0, to: 100, by: 1).map {
    HistogramBin(bin: $0, count: Float(histogram[$0, default: 0]) / Float(numSamples))
}

let mean = p * Double(numTrials)
let standardDeviation = sqrt(p * Double(numTrials) * (1 - p))

let xs = data.min()!..<data.max()!
let ys = xs.map {
    (Double($0) + 0.5).normalCdf(mean: mean, standardDeviation: standardDeviation) - (Double($0) - 0.5).normalCdf(mean: mean, standardDeviation: standardDeviation)
}

struct Point: Identifiable {
    var id: UUID = UUID()
    
    var x: Int
    var y: Double
}

let points = zip(xs, ys).map { Point(x: $0, y: $1) }


struct BarChart: View {
    var body: some View {
        VStack {
            Text("Histogram")
            Chart {
                ForEach(histogramBins) { bin in
                    BarMark(
                        x: .value("Bin", bin.bin),
                        y: .value("# of Occurences", bin.count)
                    )
                }
                
                ForEach(points) { point in
                    LineMark(
                        x: .value("x", point.x),
                        y: .value("y", point.y)
                    )
                }
                .foregroundStyle(.green)
            }
            .chartYScale(domain: 0...0.1)
            .chartYAxisLabel("Frequency")
            .chartXAxisLabel("Number of Successes")
            .frame(width: 500, height: 300)
        }
        .padding(.top, 10)
    }
}


let view = BarChart()
PlaygroundPage.current.setLiveView(view)


//: [Next](@next)
