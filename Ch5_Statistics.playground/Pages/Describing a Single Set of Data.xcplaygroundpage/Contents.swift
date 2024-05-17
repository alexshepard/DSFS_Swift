import Cocoa
import SwiftUI
import Charts
import PlaygroundSupport


extension Vector {
    // this will come in handy a few times
    // this makes a counter dict out of a list
    func counted() -> [Element: Int] {
        var counts = [Element: Int]()
        self.forEach { counts[$0, default: 0] += 1 }
        return counts
    }
    
    func mean() -> T {
        self.reduce(0, +) / T(self.count)
    }
    
    func medianOdd() -> T {
        let medianIdx = self.count / 2
        return self.sorted()[medianIdx]
    }
    
    func medianEven() -> T {
        let sorted = self.sorted()
        
        let hiMidpoint = self.count / 2
        let loMidpoint = hiMidpoint - 1
        
        return (sorted[hiMidpoint] + sorted[loMidpoint]) / 2
    }
    
    func median() -> T {
        if self.count % 2 == 0 {
            return medianEven()
        } else {
            return medianOdd()
        }
    }
    
    func quartile(p: Float) -> T {
        precondition(p <= 1)
        precondition(p > 0)
        let idx = Int(p * Float(self.count))
        return self.sorted()[idx]
    }

    func mode() -> [T] {
        let counted = self.counted()
        let maxCount = counted.values.max()
        
        let maxes = counted.filter {
            $1 == maxCount
        }
        
        return Array(maxes.keys)
    }

    func dataRange() -> T {
        return self.max()! - self.min()!
    }

    func deMean() -> Vector<T> {
        let x_bar = self.mean()
        return Vector(items: self.map { $0 - x_bar })
    }
    
    func variance() -> T {
        precondition(self.count >= 2)
        let n = self.count
        let deviations = self.deMean()
        
        return deviations.sumOfSquares() / T((n - 1))
    }

    func stdDev() -> T {
        let variance = self.variance()
        let std = sqrt(variance)
        return std
    }
    
    func iqr() -> T {
        return quartile(p: 0.75) - quartile(p: 0.25)
    }

}

let friends = Vector(items: numFriends)
let friendCounts = friends.counted()
let histogram = (0..<101).map { Int(friendCounts[Double($0), default: 0]) }

struct FriendsBin: Identifiable {
    var id: UUID = UUID()
    
    var friends: Int
    var numUsers: Int
}

let friendBins = histogram.enumerated().map { FriendsBin(friends: $0, numUsers: $1) }

struct BarChart: View {
    var body: some View {
        VStack {
            Text("Histogram of Friend Counts")
            Chart {
                ForEach(friendBins) { friendBin in
                    BarMark(
                        // have to nudge this here? why?
                        x: .value("Friends", friendBin.friends + 2),
                        y: .value("# of USers", friendBin.numUsers)
                    )
                    
                }
            }
            .chartXScale(domain: [-5, 110])
            .chartYScale(domain: [0, 25])
            .chartYAxisLabel("# of Users")
            .chartXAxisLabel("Friends")
            .frame(width: 500, height: 300)
        }
        .padding(.top, 10)
    }
}


let view = BarChart()
PlaygroundPage.current.setLiveView(view)


let numPoints = friends.count
print("There are \(numPoints) users.")

let largestValue = friends.max()!
let smallestValue = friends.min()!

print("The most friends is \(largestValue)")
print("The fewest friends is \(smallestValue)")

let sortedFriends = friends.sorted()
print(sortedFriends)

print("Smallest value is \(sortedFriends[0])")


print("Largest value is \(sortedFriends[back: 0])")
print("Second largest value is \(sortedFriends[back: 1])")

assert(Vector(items: [1, 10, 2, 9, 5]).median() == 5)
assert(Vector(items: [1, 9, 2, 10]).median() == 5.5)


assert(friends.quartile(p: 0.10) ==  1)
assert(friends.quartile(p: 0.25) ==  3)
assert(friends.quartile(p: 0.75) ==  9)
assert(friends.quartile(p: 0.90) == 13)


assert(friends.mode() == [1, 6])
assert(friends.dataRange() == 99)

// calculating the variance and/or std dev
// is consistently crashing playgrounds :(
//assert(81.54 < friends.variance())
//assert(friends.variance() < 81.55)
//assert(9.02 < friends.stdDev())
//assert(friends.stdDev() < 9.04)

assert(friends.iqr() == 6)
