//: [Previous](@previous)

import Cocoa
import SwiftUI
import Charts
import PlaygroundSupport

let mentions = [500, 505]
let years = [2017, 2018]

struct MentionCount: Identifiable {
    var id: UUID = UUID()
    
    var mentions: Int
    var year: Int
}

let mentionsByYear = zip(mentions, years).map { MentionCount(mentions: $0, year: $1) }



struct BarChart: View {
    @State private var fairAxes = "Unfair"
    let axesChoices = ["Fair", "Unfair"]
    
    var body: some View {
        VStack {
            Picker("Fair Axes", selection: $fairAxes) {
                ForEach(axesChoices, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.inline)
            
            if fairAxes == "Fair" {
                Text("Not so huge now!")
            } else {
                Text("Look at the Huge Increase!")
            }
            Chart {
                ForEach(mentionsByYear) { m in
                    BarMark(
                        x: .value("Year", m.year),
                        y: .value("# of Mentions", m.mentions)
                    )
                }
            }
            .chartYAxisLabel("# of times I heard someone say data science")
            .chartXScale(domain: [2016.5, 2018.5])
            .chartYScale(domain: fairAxes == "Fair" ? [0, 550] : [499, 506])
            .frame(width: 500, height: 300)
        }
        .padding(.top, 10)
    }
}


let view = BarChart()
PlaygroundPage.current.setLiveView(view)

//: [Next](@next)
