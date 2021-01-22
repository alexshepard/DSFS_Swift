
// intentionally sticking with arrays and dicts
// here since DSFS introduces namedtuples and 
// dataclasses in chapter 1, so that's when we'll
// start using structs :/

public struct DataSciencester {
    public static let users = [
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
    
    public static let friendship_pairs = [
        (0, 1), (0, 2), (1, 2), (1, 3), (2, 3), (3, 4),
        (4, 5), (5, 6), (5, 7), (6, 8), (7, 8), (8, 9)
    ]
    
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
        var interestsDict = [String: [Int]]()
        
        // no defaultdict
        for (_, userInterest) in DataSciencester.interests {
            if !interestsDict.keys.contains(userInterest) {
                interestsDict[userInterest] = [Int]()
            }
        }
        
        for (userId, userInterest) in DataSciencester.interests {
            interestsDict[userInterest]?.append(userId)
        }
        
        return interestsDict
    }()
    
    public static var interestsByUserId: [Int: [String]] = {
        var interestsDict = [Int: [String]]()
        
        // without defaultDict defaultdict
        for user in DataSciencester.users {
            guard let userId = user["id"] as? Int else { continue }
            interestsDict[userId] = [String]()
        }
        
        for (userId, userInterest) in DataSciencester.interests {
            interestsDict[userId]?.append(userInterest)
        }
        
        return interestsDict
    }()
    
    public static var friendships: [Int: [Int]] = {
        var friendships = [Int: [Int]]()
        for user in DataSciencester.users {
            guard let userId = user["id"] as? Int else { continue }
            friendships[userId] = [Int]()
        }
        for (userId, friendId) in DataSciencester.friendship_pairs {
            friendships[userId]?.append(friendId)
            friendships[friendId]?.append(userId)
        }
        return friendships
    }()
    
    public static let salaries_and_tenures = [
        (83_000, 8.7), (88_000, 8.1),
        (48_000, 0.7), (76_000, 6),
        (69_000, 6.5), (76_000, 7.5),
        (60_000, 2.5), (83_000, 10),
        (48_000, 1.9), (63_000, 4.2)
    ]
    
}
