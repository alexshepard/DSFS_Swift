//: [Previous](@previous)

import Cocoa
import SwiftUI
import Charts
import PlaygroundSupport


let grades = [
    83, 95, 91, 87, 70, 0, 85, 82, 100, 67, 73, 77, 0
]

let histogram = grades.map { min($0 / 10 * 10, 90) }.counted()

struct GradeBin: Identifiable {
    var id: UUID = UUID()
    
    var grade: Int
    var numStudents: Int
}

var gradeBins = stride(from: 0, to: 100, by: 10).map {
    GradeBin(grade: $0, numStudents: histogram[$0, default: 0])
}
print(gradeBins)

struct BarChart: View {
    var body: some View {
        VStack {
            Text("Distribution of Exam 1 Grades")
            Chart {
                ForEach(gradeBins) { gradeBin in
                    BarMark(
                        // have to nudge this here? why?
                        x: .value("Grade", gradeBin.grade + 2),
                        y: .value("# of Students", gradeBin.numStudents)
                    )
                    
                }
            }
            .chartXScale(domain: [-10, 110])
            .chartYScale(domain: [0, 5])
            .chartYAxis {
                AxisMarks(values: [1, 2, 3, 4, 5])
            }
            .chartXAxis {
                AxisMarks(values: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100])
            }
            .chartYAxisLabel("# of Students")
            .frame(width: 500, height: 300)
        }
        .padding(.top, 10)
    }
}


let view = BarChart()
PlaygroundPage.current.setLiveView(view)

//: [Next](@next)
