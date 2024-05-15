//: [Previous](@previous)

import Foundation

for (i, j) in friendship_pairs {
    users[i].friendships.append(j)
    users[j].friendships.append(i)
}

let totalConnections = users.map { $0.numberOfFriends }.reduce(0, +)
print("There are \(totalConnections) total connections.")
print(totalConnections)
let numUsers = users.count
let avgConnections = Float(totalConnections) / Float(numUsers)
print("\(avgConnections) average friendships per user.")

let popularUsers = users.sorted(by: { $0.numberOfFriends > $1.numberOfFriends })
print("Most popular user: \(popularUsers.first!)")

//: [Next](@next)
