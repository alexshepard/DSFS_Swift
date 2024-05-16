//: [Previous](@previous)

import Cocoa
import SwiftUI
import Charts
import PlaygroundSupport

struct Point: Identifiable {
    var id: UUID = UUID()
    
    let x: Int
    let y: Int
    let category: String
}



let variances =     [1, 2, 4, 8, 16, 32, 64, 128, 256]
let biasesSquared = [256, 128, 64, 32, 16, 8, 4, 2, 1]
let totalErrors = zip(variances, biasesSquared).map { $0 + $1 }
let xs = 0..<variances.count

var allPoints = [Point]()

for i in 0..<xs.count {
    allPoints.append(Point(x: i, y: variances[i], category: "Variance"))
    allPoints.append(Point(x: i, y: biasesSquared[i], category: "Bias"))
    allPoints.append(Point(x: i, y: totalErrors[i], category: "Total Error"))
}



struct MyChartView: View {
    
    var body: some View {
        VStack {
            Text("The Bias-Variance Tradeoff")
            Chart {
                ForEach(allPoints) {
                    LineMark(
                        x: .value("X", $0.x),
                        y: .value("Y", $0.y)
                    )
                    .foregroundStyle(
                        by: .value("Category", $0.category)
                    )
                }
                
            }
            .chartXAxisLabel("Model Complexity")

            .frame(width: 500, height: 300)
        }
        .padding(.top, 10)
    }
}

let view = MyChartView()
PlaygroundPage.current.setLiveView(view)


//: [Next](@next)
