//: [Previous](@previous)

import Cocoa
import SwiftUI
import Charts
import PlaygroundSupport

struct Movie: Identifiable {
    var id: UUID = UUID()
    
    var title: String
    var numOscars: Int
}

let movies = [
    Movie(title: "Annie Hall", numOscars: 5),
    Movie(title: "Ben-Hur", numOscars: 11),
    Movie(title: "Casablanca", numOscars: 3),
    Movie(title: "Ghandi", numOscars: 8),
    Movie(title: "West Side Story", numOscars: 10),
]

struct BarChart: View {
    var body: some View {
        VStack {
            Text("My Favorite Movies")
            Chart {
                ForEach(movies) { movie in
                    BarMark(
                        x: .value("Title", movie.title),
                        y: .value("Number of Oscars", movie.numOscars)
                    )
                }
            }
            .chartYAxisLabel("# of Academy Awards")
            .frame(width: 500, height: 300)
        }
        .padding(.top, 10)
    }
}


let view = BarChart()
PlaygroundPage.current.setLiveView(view)

//: [Next](@next)
