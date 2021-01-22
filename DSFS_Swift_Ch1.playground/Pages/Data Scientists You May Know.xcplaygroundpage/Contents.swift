/*:
 # Data Scientists You May Know
 */

//: foafs

// returns dups
func foafsBad(userId: Int) -> [Int] {
    guard let friendIds = DataSciencester.friendships[userId] else { return [] }
    
    var foafIds = [Int]()
    for friendId in friendIds {
        foafIds.append(contentsOf: DataSciencester.friendships[friendId] ?? [])
    }
    
    return foafIds
}

if let hero = DataSciencester.users.first,
   let id = hero["id"] as? Int
{
    print(foafsBad(userId: id))
}

func foafIds(userId: Int) -> [Int] {
    return Array(Set(foafsBad(userId: userId)))
}

if let hero = DataSciencester.users.first,
   let id = hero["id"] as? Int
{
    print(foafIds(userId: id))
}

func mutualFriendCounter(userId: Int) -> [Int: Int] {
    guard let userFriends = DataSciencester.friendships[userId] else { return [:] }
    
    // get foafs that aren't me and aren't my friends
    let strictFoafs = foafIds(userId: userId).filter { 
        if $0 == userId { return false } // not me
        if userFriends.contains($0) { return false } // not my friend
        return true
    }
    
    // count the mutual friends of our strict foafs
    var mutualFriendCounts = [Int: Int]()
    for foaf in strictFoafs {
        let mutualFriends = DataSciencester.friendships[foaf]?.filter {
            return userFriends.contains($0)
        }
        mutualFriendCounts[foaf] = mutualFriends?.count
    }
    
    return mutualFriendCounts
}

print(mutualFriendCounter(userId: 3))

//: shared interests

// naive implementation
func dataScientistsWhoLike(interest: String) -> [Int] {
    
    let interestedParties = DataSciencester.users.filter {
        guard let userId = $0["id"] as? Int else { return false }
        
        for (candidateUserId, candidateInterest) in DataSciencester.interests {
            if userId == candidateUserId && interest == candidateInterest { return true }
        }
        
        return false
    }
    
    // convert to userIds and filter out nils with compactMap
    return interestedParties.compactMap { $0["id"] as? Int }
}

print(dataScientistsWhoLike(interest: "Java"))

// better implementation, using created index
// but is optionals :/
// better still as function on DataSciencester
// but that's getting pretty far from the DSFS book
print(DataSciencester.userIdsByInterest["Java"])
print(DataSciencester.interestsByUserId[4])

func commonInterestsWith(userId: Int) -> [Int: Int] {
    guard let userInterests = DataSciencester.interestsByUserId[userId] else { return [:] }
    var sharedInterestCount = [Int: Int]()
    
    for other in DataSciencester.users {
        guard let otherId = other["id"] as? Int else { continue }
        if otherId == userId { continue }
        guard let otherInterests = DataSciencester.interestsByUserId[otherId] else { continue }
        
        sharedInterestCount[otherId] = userInterests.filter {
            (otherInterests.contains($0)) 
        }.count
    }
    
    return sharedInterestCount
}

print(commonInterestsWith(userId: 9))
