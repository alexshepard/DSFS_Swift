//: [Previous](@previous)

import Foundation

enum Kid: Int, CaseIterable {
    case boy = 0
    case girl = 1
    
    static func randomKid() -> Kid {
        self.allCases.randomElement()!
    }
}

var bothGirls = 0.0
var olderGirl = 0.0
var eitherGirl = 0.0

for _ in 0..<10_000 {
    let younger = Kid.randomKid()
    let older = Kid.randomKid()
    
    if older == .girl {
        olderGirl += 1
    }
    if older == .girl && younger == .girl {
        bothGirls += 1
    }
    if older == .girl || younger == .girl {
        eitherGirl += 1
    }
}

print("P(both|older): \(bothGirls / olderGirl)")
print("P(both|either): \(bothGirls / eitherGirl)")

//: [Next](@next)
