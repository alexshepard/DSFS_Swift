
import Cocoa
import SwiftUI
import Charts
import PlaygroundSupport

struct Point: Identifiable {
    var id: UUID = UUID()
    
    let x: Int
    let y: Double
}
                                

let years = [1950, 1960, 1970, 1980, 1990, 2000, 2010]
let gdps = [300.2, 543.3, 1075.9, 2862.5, 5979.6, 10289.7, 14958.3]

let points = zip(years, gdps).map { Point(x: $0, y: $1) }


struct MyChartView: View {
    
    var body: some View {
        VStack {
            Text("Nominal GDP")
            Chart {
                ForEach(points) {
                    PointMark(
                        x: .value("X", $0.x),
                        y: .value("Y", $0.y)
                    )
                    .foregroundStyle(.green)
                }
                ForEach(points) {
                    LineMark(
                        x: .value("X", $0.x),
                        y: .value("Y", $0.y)
                    )
                    .foregroundStyle(.green)
                }
            }
            .chartXScale(domain: [1945, 2015])
            .chartXAxis {
                AxisMarks(
                    format: Decimal.FormatStyle().grouping(.never),
                    values: .automatic(desiredCount: years.count))
            }
            .chartYAxisLabel("Billions of $")
            .frame(width: 500, height: 300)
        }
        .padding(.top, 10)
    }
}

let view = MyChartView()
PlaygroundPage.current.setLiveView(view)

