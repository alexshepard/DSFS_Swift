import Cocoa
import Numerics

/// bringing this forward from Ch4 on Linear Algebra
struct Vector<T: Real>: Collection, Equatable {
    private var items: [T]

    init(items: [T]) {
        self.items = items
    }

    // Collection conformance
    var startIndex: Int { items.startIndex }
    var endIndex: Int { items.endIndex }

    func index(after i: Int) -> Int {
        items.index(after: i)
    }

    subscript(index: Int) -> T {
        get { items[index] }
        set { items[index] = newValue }
    }
}

extension Vector {
    func dot(other: Vector<T>) -> T {
        precondition(self.count == other.count, "Vectors must be the same length to compute dot product.")
        return zip(self, other).map(*).reduce(0, +)
    }

    /// The sum of the elements squared.
    func sumOfSquares() -> T {
        return dot(other: self)
    }
}

let ss = Vector(items: [1, 2, 3, 4]).sumOfSquares()
let ss2 = Vector(items: [1.0, 2.0, 3.0, 4.0]).sumOfSquares()

print(ss, ss2)

/// we'll want to minimize this kind of function (sum of squared error)
