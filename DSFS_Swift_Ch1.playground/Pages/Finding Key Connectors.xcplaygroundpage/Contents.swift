/*:
 # Finding Key Connectors
 */

//: find the total & average number of connections

var friendships = [Int: [Int]]()
for user in DataSciencester.users {
    guard let userId = user["id"] as? Int else { continue }
    friendships[userId] = [Int]()
}
for (userId, friendId) in DataSciencester.friendship_pairs {
    friendships[userId]?.append(friendId)
    friendships[friendId]?.append(userId)
}

func numberOfFriends(userId: Int) -> Int {
    // how many friends does user have?
    guard let friendIds = friendships[userId] else { return 0 }
    return friendIds.count
}

var totalConnections = 0
for user in DataSciencester.users {
    guard let userId = user["id"] as? Int else { continue }
    totalConnections += numberOfFriends(userId: userId)
}
print(totalConnections)

let avgConnections = Float(totalConnections) / Float(DataSciencester.users.count)
print(avgConnections)

//: find the most & least popular

// following the book, construct and sort array
// of tuples (user_id, num_friends)
var numFriendsById = [(Int, Int)]()
for user in DataSciencester.users {
    guard let userId = user["id"] as? Int else { continue }
    numFriendsById.append( (userId, numberOfFriends(userId: userId)) )
}

let popular = numFriendsById.sorted { (a, b) -> Bool in 
    return a.1 > b.1
}
print(popular)

