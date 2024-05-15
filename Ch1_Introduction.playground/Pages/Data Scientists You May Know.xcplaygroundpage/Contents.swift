//: [Previous](@previous)

import Foundation

for (i, j) in friendship_pairs {
    users[i].friendships.append(j)
    users[j].friendships.append(i)
}


extension User {
    func foafIdsBad() -> [Int] {
        // "bad" because it lists people more than once and also lists me
        return self.friendships.flatMap { users[$0].friendships }
    }
    
    func friendsOfFriends() -> [Int: Int] {
        var foafs = [Int: Int]()
        
        // candidates are other people who i'm not friends with
        let candidates = users.filter { $0 != self && !friendships.contains($0.id) }
        
        for candidate in candidates {
            // the intersection of my friends and the candidate's friends is our foafs
            foafs[candidate.id] = Set(candidate.friendships).intersection(Set(friendships)).count
        }
        
        // only include candidates with at least 1 friend in common
        return foafs.filter { $1 != 0 }
    }
}

print("Hero's friends (bad): \(users.first!.foafIdsBad())")
print("Chi's friends in common: \(users[3].friendsOfFriends())")

for (i, j) in interests {
    users[i].interests.append(j)
}
print("Hero with interests \(users.first!)")

// hadoop -> [Joe, Bluey, Laurie]
func dataScientistsWhoLike(_ interest: String) -> [User] {
    users.filter { $0.interests.contains(interest) }
}
print("Data scientists who like hadoop: \(dataScientistsWhoLike("Hadoop"))")

// hadoop: [3, 4, 5]
var userIdsByInterests = [String: [Int]]()
for (userId, interest) in interests {
    userIdsByInterests[interest, default: [Int]()].append(userId)
}
print("User IDs by interests: \(userIdsByInterests)")


extension User {
    func commonInterests() -> [Int:Int] {
        // get related interests first
        var relatedInterests = self.interests.compactMap {
            return userIdsByInterests[$0]?.filter {
                // don't include me
                $0 != self.id
            }
        }.reduce([], +)
        
        // we now have a list of user ids where each common interest
        // shared with me is listed. if we have 2 common interests,
        // they're listed twice, if 3, thrice. so next we count them
        return relatedInterests.counted()
    }
}

let commonInterests = users.first!.commonInterests()
print("The users with common interests of \(users.first!.name) are: \(commonInterests.map { (users[$0].name, $1) })")

//: [Next](@next)
