//: [Previous](@previous)

import Foundation

let friends = Vector(items: numFriends)
let mins = Vector(items: dailyMinutes)
let hours = mins / 60

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

extension Vector {
    func covariance(other: Vector) -> T {
        precondition(self.count == other.count)
        return self.deMean().dot(other: other.deMean()) / T((self.count - 1))
    }
    
    func correlation(other: Vector) -> T {
        precondition(self.count == other.count)
        
        let selfStdDev = self.stdDev()
        let otherStdDev = other.stdDev()
        if selfStdDev > 0 && otherStdDev > 0 {
            return self.covariance(other: other) / selfStdDev / otherStdDev
        } else {
            // if there's no variation, then no correlation
            return 0
        }
    }
}

assert(22.42 < friends.covariance(other: mins))
assert(friends.covariance(other: mins) < 22.43)
assert(22.42 / 60 < friends.covariance(other: hours))
assert(friends.covariance(other: hours) < 22.43 / 60)

assert(0.24 < friends.correlation(other: mins))
assert(friends.correlation(other: mins) < 0.25)
assert(0.24 < friends.correlation(other: hours))
assert(friends.correlation(other: hours) < 0.25)

if let outlierIndex = friends.firstIndex(of: 100) {
    let friendsGood = Vector(items: friends.enumerated().filter { $0.offset != outlierIndex }.map { $0.element })
    let minsGood = Vector(items: mins.enumerated().filter { $0.offset != outlierIndex }.map { $0.element })
    assert(0.57 < friendsGood.correlation(other: minsGood))
    assert(friends.correlation(other: mins) < 0.58)
}

//: [Next](@next)
