
public struct User {
    public var id: Int
    public var name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

public struct DataSciencester {
    static let users_dict = [
        ["id": 0, "name": "Hero"],
        ["id": 1, "name": "Dunn"],
        ["id": 2, "name": "Sue"],
        ["id": 3, "name": "Chi"],
        ["id": 4, "name": "Thor"],
        ["id": 5, "name": "Clive"],
        ["id": 6, "name": "Hicks"],
        ["id": 7, "name": "Devin"],
        ["id": 8, "name": "Kate"],
        ["id": 9, "name": "Klein"]
    ]
    
    // let's use an array of structs instead
    // of [String: Any] dicts which aren't as safe
    public static var users: [User] = {
        var users = [User]()
        for u in users_dict {
            guard let userId = u["id" ] as? Int else { continue }
            guard let name = u["name"] as? String else { continue }
            let user = User(id: userId, name: name)
            users.append(user)
        }
        return users
    }()
    
    static let friendshipPairs = [
        (0, 1), (0, 2), (1, 2), (1, 3), (2, 3), (3, 4),
        (4, 5), (5, 6), (5, 7), (6, 8), (7, 8), (8, 9)
    ]
    
    
    public static var friendships: [Int: [Int]] = {
        var friendships = [Int: [Int]]()
        for user in DataSciencester.users {
            friendships[user.id] = [Int]()
        }
        for (userId, friendId) in DataSciencester.friendshipPairs {
            friendships[userId]?.append(friendId)
            friendships[friendId]?.append(userId)
        }
        
        return friendships
    }()
    
    public static let interests = [
        (0, "Hadoop"), (0, "Big Data"), (0, "HBase"), (0, "Java"),
        (0, "Spark"), (0, "Storm"), (0, "Cassandra"),
        (1, "NoSQL"), (1, "MongoDB"), (1, "Cassandra"), (1, "HBase"),
        (1, "Postgres"), (2, "Python"), (2, "scikit-learn"), (2, "scipy"),
        (2, "numpy"), (2, "statsmodels"), (2, "pandas"), (2, "R"), (3, "python"),
        (3, "statistics"), (3, "regression"), (3, "probability"),
        (4, "machine learning"), (4, "regression"), (4, "decision trees"),
        (4, "libsvm"), (5, "python"), (5, "R"), (5, "Java"), (5, "C++"),
        (5, "Haskell"), (5, "programming languages"), (6, "statistics"),
        (6, "probability"), (6, "mathematics"), (6, "theory"),
        (7, "machine learning"), (7, "scikit-learn"), (7, "Mahout"),
        (7, "neural networks"), (8, "neural networks"), (8, "deep learning"),
        (8, "Big Data"), (8, "artificial intelligence"), (9, "Hadoop"),
        (9, "Java"), (9, "MapReduce"), (9, "Big Data")
    ]
    
    public static var userIdsByInterest: [String: [Int]] = {
        // hacking together without defaultdict
        var interestsDict = [String: [Int]]()
        
        var uniqueInterests = Set<String>()
        for (_, userInterest) in DataSciencester.interests {
            uniqueInterests.insert(userInterest)
        }
        
        for interest in uniqueInterests {
            interestsDict[interest] = [Int]()
        }
        
        for (userId, userInterest) in DataSciencester.interests {
            interestsDict[userInterest]?.append(userId)
        }
        print("Interests Dict \(interestsDict)")
        
        return interestsDict ?? [String: [Int]]()
    }()
    
    public static var interestsByUserId: [Int: [String]] = {
        // hacking together without defaultdict
        var interestsDict = [Int: [String]]()
        // assume user interests and users intersect
        for user in DataSciencester.users {
            interestsDict[user.id] = [String]()
        }
        
        for (userId, userInterest) in DataSciencester.interests {
            interestsDict[userId]?.append(userInterest)
        }
        
        return interestsDict
    }()
}
