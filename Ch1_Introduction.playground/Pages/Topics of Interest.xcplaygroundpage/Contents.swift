//: [Previous](@previous)

import Foundation

let words = interests.flatMap { $1.lowercased().split(separator: " ") }
let wordsAndCounts = words.counted()
print(wordsAndCounts.filter { $1 > 1 })

//: [Next](@next)
