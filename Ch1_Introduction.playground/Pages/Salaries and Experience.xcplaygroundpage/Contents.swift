//: [Previous](@previous)

import Cocoa
import SwiftUI
import Charts
import PlaygroundSupport


struct Point: Identifiable {
    var id: UUID = UUID()
    
    let x: Double
    let y: Int
}

let ds = salaries_and_tenures.map { Point(x: $1, y: $0) }

                                
struct MyChartView: View {
    var body: some View {
        Chart {
            ForEach(ds) {
                PointMark(
                    x: .value("X", $0.x),
                    y: .value("Y", $0.y)
                )
                .foregroundStyle(.blue)
            }
        }
        .frame(width: 500, height: 500)
        .padding(.top, 50)
    }
}

let view = MyChartView()
PlaygroundPage.current.setLiveView(view)

func bucketFor(tenure: Double) -> String {
    if tenure < 2 {
        return "less than two"
    } else if tenure < 5 {
        return "between two and five"
    } else {
        return "more than five"
    }
}

var salaryByTenureBucket = [String: [Int]]()
for (salary, tenure) in salaries_and_tenures {
    let bucket = bucketFor(tenure: tenure)
    salaryByTenureBucket[bucket, default: [Int]()].append(salary)
}

print(salaryByTenureBucket.map {
    ($0, $1.reduce(0, +) / $1.count)
})

//: [Next](@next)
