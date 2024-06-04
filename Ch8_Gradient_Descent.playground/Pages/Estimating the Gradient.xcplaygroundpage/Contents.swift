//: [Previous](@previous)

import Foundation
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

    /// Broadcast addition of a vector by a scalar.
    static func +(lhs: Vector<T>, rhs: T) -> Vector {
        Vector(items: lhs.map { $0 + rhs })
    }

    /// Broadcast subtraction of a vector by a scalar.
    static func -(lhs: Vector<T>, rhs: T) -> Vector {
        Vector(items: lhs.map { $0 - rhs })
    }

}


func differenceQuotient<T>(f: (Vector<T>) -> T, x: Vector<T>, h: T) -> T {
    return (f(x + h) - f(x)) / h
}



let diff = differenceQuotient(f: { $0.dot(other: $0) }, x: Vector(items: [1.0, 2.0, 3.0]), h: 0.01)
print(diff)

/// as h goes to zero, difference gets closer to 12
print("looking at vector fn difference quotient for different values of h")
for i in 0..<30 {
    let h = 1 / pow(2, Double(i))
    let diff = differenceQuotient(f: { $0.dot(other: $0) }, x: Vector(items: [1.0, 2.0, 3.0]), h: h)
    print(h, diff)
}
print("converges to 12")

/// some derivatives
func squareFn(x: Double) -> Double {
    return x * x
}

func derivativeOfSquareFn(x: Double) -> Double {
    return 2 * x
}

func differenceQuotientSingle<T: FloatingPoint>(f: (T) -> T, x: T, h: T) -> T {
    return (f(x + h) - f(x)) / h
}

print("looking at single value fn difference quotient for different values of h")
for i in 0..<15 {
    let h = 1 / pow(2, Double(i))
    let diff = differenceQuotientSingle(f: squareFn, x: 1.0, h: h)
    print(h, diff)
}
print("converges to 2 for square of 1")

print("checking our concept of the derivative of squareFn")
for i in 0..<10 {
    let h: Double = 0.000001
    let diff = differenceQuotientSingle(f: squareFn, x: Double(i), h: h)
    let dd = derivativeOfSquareFn(x: Double(i))
    print(i, diff, dd)
}
print("checks out 👍")






//: [Next](@next)
