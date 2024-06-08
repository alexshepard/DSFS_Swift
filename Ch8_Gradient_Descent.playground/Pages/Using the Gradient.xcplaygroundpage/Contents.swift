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

    /// Broadcast multiplication of a vector by a scalar.
    static func *(lhs: Vector<T>, rhs: T) -> Vector {
        Vector(items: lhs.map { $0 * rhs })
    }
    
    /// Broadcast multiplication of a vector by a scalar.
    static func +(lhs: Vector<T>, rhs: T) -> Vector {
        Vector(items: lhs.map { $0 + rhs })
    }
    
    static func +(lhs: Vector<T>, rhs: Vector<T>) -> Vector {
        precondition(lhs.count == rhs.count, "Vectors must be the same length to add.")
        return Vector(items: zip(lhs, rhs).map { $0 + $1 })
    }

}

let a = Vector(items: [0, 1, 2])
print(a)

func gradientStep<T>(v: Vector<T>, gradient: Vector<T>, stepSize: T) -> Vector<T> {
    precondition(v.count == gradient.count)
    let step = gradient * stepSize
    return v + step
}

func sumOfSquaresGradient<T>(v: Vector<T>) -> Vector<T> {
    Vector(items: v.map { 2 * $0 })
}

var v = Vector(items: (0..<10).map { _ in Double.random(in: -10..<10) })
print(v)

for epoch in 0..<1_000 {
    let grad = sumOfSquaresGradient(v: v)
    v = gradientStep(v: v, gradient: grad, stepSize: -0.01)
    print(epoch, v.map { abs($0) }.reduce(0, +))
}



//: [Next](@next)
