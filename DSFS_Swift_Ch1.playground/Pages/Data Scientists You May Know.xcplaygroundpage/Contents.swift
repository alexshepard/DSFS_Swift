/*:
 # Data Scientists You May Know
 */

//: foafs

func foafIdsDups(user: User) -> [Int] {
    guard let friends = DataSciencester.friendships[user.id] else { return [] }
    
    // seems like we should be abel to do this in one step?
    let foafIds = friends
        .flatMap { DataSciencester.friendships[$0] } // unwrap optionals
        .flatMap { $0 }                              // flatten
    return foafIds
}

if let hero = DataSciencester.users.first {
    print(foafIdsDups(user: hero))
}

func foafIds(user: User) -> [Int] {
    return Array(Set(foafIdsDups(user: user)))
}

if let hero = DataSciencester.users.first {
    print(foafIds(user: hero))
}

func mutualFriendCounter(user: User) -> [Int: Int] {
    guard let userFriends = DataSciencester.friendships[user.id] else { return [:] }
    
    // get foafs that aren't me and aren't my friends
    let strictFoafs = foafIds(user: user).filter { 
        if $0 == user.id { return false } // not me
        if userFriends.contains($0) { return false } // not my friend
        return true
    }
    
    // count the mutual friends of our strict foafs
    let mutualFriendCounts = strictFoafs.reduce([Int: Int]()) { (dict, foafId) -> [Int : Int] in
        var dict = dict
        let mutualFriends = DataSciencester.friendships[foafId]?.filter {
            return userFriends.contains($0)
        }
        dict[foafId] = mutualFriends?.count ?? 0
        return dict
    }
    
    return mutualFriendCounts
}

let chi = DataSciencester.users[3]
print(mutualFriendCounter(user: chi))

//: shared interests

// naive implementation
func dataScientistsWhoLike(interest: String) -> [Int] {
    return DataSciencester.users.filter { 
        for (userId, userInterest) in DataSciencester.interests {
            if userId == $0.id && interest == userInterest { return true }
        }
        return false
    }.map { $0.id }
}

print(dataScientistsWhoLike(interest: "Java"))

// better implementation, using created index
// but is optionals :/
// better still as function on DataSciencester
// but that's getting pretty far from the DSFS book
print(DataSciencester.userIdsByInterest["Java"])
print(DataSciencester.interestsByUserId[4])

func commonInterestsWith(user: User) -> [Int: Int] {
    guard let userInterests = DataSciencester.interestsByUserId[user.id] else { return [:] }
    var sharedInterests = [Int: Int]()
    
    for other in DataSciencester.users {
        if other.id == user.id { continue }
        guard let otherInterests = DataSciencester.interestsByUserId[other.id] else { continue }
        
        sharedInterests[other.id] = userInterests.filter { (otherInterests.contains($0)) }.count
    }
    
    return sharedInterests
}

let klein = DataSciencester.users[9]
print(commonInterestsWith(user: klein))

