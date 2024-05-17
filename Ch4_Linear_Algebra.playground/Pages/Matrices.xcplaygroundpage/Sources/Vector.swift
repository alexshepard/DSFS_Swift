import Foundation

public struct Vector<T: FloatingPoint>: Collection, Equatable {
    private var items: [T]
    
    public init(items: [T]) {
        self.items = items
    }
    
    // Collection conformance
    public var startIndex: Int { items.startIndex }
    public var endIndex: Int { items.endIndex }
    
    public func index(after i: Int) -> Int {
        items.index(after: i)
    }

    public subscript(index: Int) -> T {
        get { items[index] }
        set { items[index] = newValue }
    }
}

// Arithmetic operations
extension Vector {
    /// Adds corresponding elements.
    public static func +(lhs: Vector<T>, rhs: Vector<T>) -> Vector {
        precondition(lhs.count == rhs.count, "Vectors must be the same length to add.")
        return Vector(items: zip(lhs, rhs).map(+))
    }
    
    /// Subtracts corresponding elements.
    public static func -(lhs: Vector<T>, rhs: Vector<T>) -> Vector {
        precondition(lhs.count == rhs.count, "Vectors must be the same length to subtract.")
        return Vector(items: zip(lhs, rhs).map(-))
    }
    
    /// Multiples the vector by a scalar.
    public static func *(lhs: Vector<T>, rhs: T) -> Vector {
        Vector(items: lhs.map { $0 * rhs })
    }
    
    /// Multiples a scalar by a vector.
    public static func *(lhs: T, rhs: Vector<T>) -> Vector { rhs * lhs }
    
    public static func /(lhs: Vector<T>, rhs: T) -> Vector {
        Vector(items: lhs.map { $0 / rhs })
    }
}

// Statistical operations
extension Vector {
    /// Sums all corresponding elements.
    public static func vectorSum(_ vectors: [Vector<T>]) -> Vector {
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
    public static func vectorMean(_ vectors: [Vector<T>]) -> Vector {
        precondition(!vectors.isEmpty, "No vectors provided.")
        let lens = Set(vectors.map { $0.count })
        precondition(lens.count == 1, "All vectors must be the same size.")
        
        return vectorSum(vectors) / T(vectors.count)
    }
}

// Vector properties
extension Vector {
    /// Computes the sum of elementwise products.
    public func dot(other: Vector<T>) -> T {
        precondition(self.count == other.count, "Vectors must be the same length to compute dot product.")
        return zip(self, other).map(*).reduce(0, +)
    }
    
    /// The sum of the elements squared.
    public func sumOfSquares() -> T {
        return dot(other: self)
    }
    
    /// The magnitude (or length).
    public func magnitude() -> T {
        return sqrt(self.sumOfSquares())
    }
    
    /// Computes the distance between two vectors.
    public func distance(other: Vector<T>) -> T {
        (self - other).magnitude()
    }
}

extension Vector: CustomStringConvertible {
    public var description: String {
        return items.description
    }
}
