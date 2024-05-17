//: [Previous](@previous)

import Foundation

struct Vector<T: FloatingPoint>: Collection, Equatable {
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

// Arithmetic operations
extension Vector {
    /// Adds corresponding elements.
    static func +(lhs: Vector<T>, rhs: Vector<T>) -> Vector {
        precondition(lhs.count == rhs.count, "Vectors must be the same length to add.")
        return Vector(items: zip(lhs, rhs).map(+))
    }
    
    /// Subtracts corresponding elements.
    static func -(lhs: Vector<T>, rhs: Vector<T>) -> Vector {
        precondition(lhs.count == rhs.count, "Vectors must be the same length to subtract.")
        return Vector(items: zip(lhs, rhs).map(-))
    }
    
    /// Multiples the vector by a scalar.
    static func *(lhs: Vector<T>, rhs: T) -> Vector {
        Vector(items: lhs.map { $0 * rhs })
    }
    
    /// Multiples a scalar by a vector.
    static func *(lhs: T, rhs: Vector<T>) -> Vector { rhs * lhs }
    
    static func /(lhs: Vector<T>, rhs: T) -> Vector {
        Vector(items: lhs.map { $0 / rhs })
    }
}

// Statistical operations
extension Vector {
    /// Sums all corresponding elements.
    static func vectorSum(_ vectors: [Vector<T>]) -> Vector {
        precondition(!vectors.isEmpty, "No vectors provided.")
        let lens = Set(vectors.map { $0.count })
        precondition(lens.count == 1, "All vectors must be the same size.")
        
        // this feels clunky, but it's basically what's in the book
        let numElements = vectors[0].count
        let sums = (0..<numElements).map { idx in
            vectors.map { $0[idx] }.reduce(0, +)
        }
        return Vector(items: sums)
    }
    
    /// The elementwise average.
    static func vectorMean(_ vectors: [Vector<T>]) -> Vector {
        precondition(!vectors.isEmpty, "No vectors provided.")
        let lens = Set(vectors.map { $0.count })
        precondition(lens.count == 1, "All vectors must be the same size.")
        
        return vectorSum(vectors) / T(vectors.count)
    }
}

// Vector properties
extension Vector {
    /// Computes the sum of elementwise products.
    func dot(other: Vector<T>) -> T {
        precondition(self.count == other.count, "Vectors must be the same length to compute dot product.")
        return zip(self, other).map(*).reduce(0, +)
    }
    
    /// The sum of the elements squared.
    func sumOfSquares() -> T {
        return dot(other: self)
    }
    
    /// The magnitude (or length).
    func magnitude() -> T {
        return sqrt(self.sumOfSquares())
    }
    
    /// Computes the distance between two vectors.
    func distance(other: Vector<T>) -> T {
        (self - other).magnitude()
    }
}

extension Vector: CustomStringConvertible {
    var description: String {
        return items.description
    }
}


let heightWeightAge = Vector(items: [70, 140, 40])
let grades = Vector(items: [95, 80, 75, 62])

assert(Vector(items: [1, 2, 3]) + Vector(items: [4, 5, 6]) == Vector(items: [5, 7, 9]))
assert(Vector(items: [5, 7, 9]) - Vector(items: [4, 5, 6]) == Vector(items: [1, 2, 3]))

assert(Vector.vectorSum([
    Vector(items: [1, 2]),
    Vector(items: [3, 4]),
    Vector(items: [5, 6]),
    Vector(items: [7, 8]),
]) == Vector(items: [16, 20]))


print(heightWeightAge)

assert(heightWeightAge * 3 == Vector(items:[210, 420, 120]))
assert(heightWeightAge * 3 == 3 * heightWeightAge)
assert(2 * Vector(items: [1, 2, 3]) == Vector(items: [2, 4, 6]))

assert(Vector.vectorMean([
    Vector(items: [1, 2]),
    Vector(items: [3, 4]),
    Vector(items: [5, 6])
]) == Vector(items: [3, 4]))

assert(Vector(items: [1, 2, 3]).dot(other: Vector(items: [4, 5, 6])) == 32)

assert(Vector(items: [1, 2, 3]).sumOfSquares() == 14)

// thank you pythagoras
assert(Vector(items: [3, 4]).magnitude() == 5)

print(Vector(items: [3, 4]).distance(other: Vector(items: [14, 32])))

//: [Next](@next)
