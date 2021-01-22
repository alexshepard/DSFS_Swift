/*:
 # Topics of Interest
 */

//: Count the popular words in users' interests.
var words_and_counts = [String: Int]()
for (userId, userInterest) in DataSciencester.interests {
    let words = userInterest.split(separator: " ")
    for word in words {
        let lc_string_word = String(word).lowercased()
        if words_and_counts[lc_string_word] == nil {
            words_and_counts[lc_string_word] = 1
        } else {
            words_and_counts[lc_string_word]! += 1
        }
    }
}

let most_popular_interests = words_and_counts.keys.sorted {
    words_and_counts[$0]! > words_and_counts[$1]!
}
for interest in most_popular_interests {
    guard let count = words_and_counts[interest] else { continue }
    if count > 1 {
        print(interest, count)
    }
}
