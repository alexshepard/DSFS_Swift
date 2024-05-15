import Foundation

public extension Array where Element: Hashable {
    // this will come in handy a few times
    // this makes a counter out of a dict
    func counted() -> [Element: Int] {
        var counts = [Element: Int]()
        self.forEach { counts[$0, default: 0] += 1 }
        return counts
    }
}
