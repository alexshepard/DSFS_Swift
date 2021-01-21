/*:
 # Finding Key Connectors
 */

//: find the total & average number of connections

func numberOfFriends(user: User) -> Int {
    // how many friends does user have?
    guard let friendIds = DataSciencester.friendships[user.id] else { return 0 }
    return friendIds.count
}

var totalConnections = DataSciencester.users.reduce(0) {
    $0 + numberOfFriends(user: $1)
}
print(totalConnections)

let avgConnections = Float(totalConnections) / Float(DataSciencester.users.count)
print(avgConnections)

//: find the most & least popular

print(DataSciencester.users.sorted { 
    numberOfFriends(user: $0) > numberOfFriends(user: $1)
})

// or, following the book, construct and sort array
// of tuples (user_id, num_friends)
let numFriendsById = DataSciencester.users.map { 
    ($0.id, numberOfFriends(user: $0)) 
}
let popular = numFriendsById.sorted { (a, b) -> Bool in 
    return a.1 > b.1
}
print(popular)

