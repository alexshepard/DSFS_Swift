//: [Previous](@previous)

import Cocoa
import SwiftUI
import Charts
import PlaygroundSupport

struct Point: Identifiable {
    var id: UUID = UUID()
    
    let x: Int
    let y: Int
}

let numFriends = [70, 65, 72, 63, 71, 64, 60, 64, 67]
let minsOnSite = [175, 170, 205, 120, 220, 130, 105, 145, 190]


let points = zip(numFriends, minsOnSite).map {
    Point(x: $0, y: $1)
}




struct MyChartView: View {
    
    var body: some View {
        VStack {
            Text("Daily Minutes vs Number of Friends")
            Chart {
                ForEach(points) {
                    PointMark(
                        x: .value("X", $0.x),
                        y: .value("Y", $0.y)
                    )
                }
                
            }
            .chartYAxisLabel("time on site")
            .chartXAxisLabel("# of friends")
            .chartXScale(domain: [58, 73])
            .chartYScale(domain: [90, 230])
            .frame(width: 500, height: 300)
        }
        .padding(.top, 10)
    }
}

let view = MyChartView()
PlaygroundPage.current.setLiveView(view)


//: [Next](@next)
