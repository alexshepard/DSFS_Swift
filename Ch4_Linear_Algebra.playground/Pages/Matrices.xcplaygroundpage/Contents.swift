//: [Previous](@previous)

import Foundation

struct Matrix<T: FloatingPoint>: Equatable {
    private let rows: Int
    private let cols: Int
    var items: [T]
    
    /// initializer for creating a matrix with an initial value
    init(rows: Int, cols: Int, initialValue: T) {
        precondition(rows > 0)
        precondition(cols > 0)
        
        self.rows = rows
        self.cols = cols
        self.items = [T].init(repeating: initialValue, count: rows * cols)
    }
    
    /// initializer for creating a matrix from a rectangular list of lists
    init(grid: [[T]]) {
        precondition(!grid.isEmpty, "Grid cannot be empty.")
        let lens = Set(grid.map { $0.count })
        precondition(lens.count == 1, "All rows in the grid must have the same size.")
        
        self.rows = grid.count
        self.cols = grid[0].count
        self.items = grid.flatMap { $0 }
    }
    
    init(grid: [Vector<T>]) {
        precondition(!grid.isEmpty, "Grid cannot be empty.")
        let lens = Set(grid.map { $0.count })
        precondition(lens.count == 1, "All rows in the grid must have the same size.")
        
        self.rows = grid.count
        self.cols = grid[0].count
        self.items = grid.flatMap { $0 }
    }
    
    /// used internally
    private init(rows: Int, cols: Int, items: [T]) {
        self.rows = rows
        self.cols = cols
        self.items = items
    }
    
    var shape: (Int, Int) {
        return (rows, cols)
    }
    
    func indexIsValid(row: Int, col: Int) -> Bool {
        return row >= 0 && row < rows && col >= 0 && col < cols
    }
    
}

// indexing
extension Matrix {
    /// accessing and setting element by row and col
    subscript(row: Int, col: Int) -> T {
        get {
            precondition(indexIsValid(row: row, col: col))
            return items[(row * cols) + col]
        }
        
        set {
            precondition(indexIsValid(row: row, col: col))
            items[(row * cols) + col] = newValue
        }
    }
    
    /// whole row subscript
    subscript(row: Int) -> Vector<T> {
        get {
            precondition(indexIsValid(row: row, col: 0))
            return Vector(items: (0..<cols).map { self[row, $0] })
        }
        set {
            precondition(indexIsValid(row: row, col: 0))
            precondition(newValue.count == cols)
            for col in 0..<cols {
                self[row, col] = newValue[col]
            }
        }
    }
    
    /// whole column subscript
    subscript(col colIndex: Int) -> Vector<T> {
        get {
            precondition(indexIsValid(row: 0, col: colIndex))
            return Vector(items: (0..<rows).map { self[$0, colIndex] })
        }
        set {
            precondition(indexIsValid(row: 0, col: colIndex))
            precondition(newValue.count == rows)
            for row in 0..<rows {
                self[row, colIndex] = newValue[colIndex]
            }
        }
    }
}

// convenience initializers
extension Matrix {
    /// Create a matrix of all zeros.
    static func zeros(rows: Int, cols: Int) -> Matrix {
        return Matrix(rows: rows, cols: cols, initialValue: 0)
    }
    
    /// Create a matrix of all ones.
    static func ones(rows: Int, cols: Int) -> Matrix {
        return Matrix(rows: rows, cols: cols, initialValue: 1)
    }
    
    /// Create an identity matrix.
    static func eye(size: Int) -> Matrix {
        let items: [T] = (0..<size*size).map {
            ($0 / size == $0 % size) ? 1 : 0
        }
        return Matrix(rows: size, cols: size, items: items)
    }
}

// Custom description for printing the matrix
extension Matrix: CustomStringConvertible {
    var description: String {
        (0..<rows).map { row in
            self[row].map { item in
                String(describing: item)
            }.joined(separator: " ")
        }.joined(separator: "\n")
    }
}



let A = Matrix(grid:
                [[1, 2, 3],
                 [4, 5, 6]]
)

let B = Matrix(grid:
                [[1, 2],
                 [3, 4],
                 [5, 6]]
)

print(A)
print(A.shape)
print(B)
print(B.shape)

print(A[1, 2])

let C = Matrix(grid: [[1, 2, 3]])
let D = Matrix(grid:
                [[1],
                 [2],
                 [3]]
)
print(C)
print(D)


assert(A[0, 0] == 1)
assert(A[0, 2] == 3)
assert(A[1, 1] == 5)
assert(A[1, 2] == 6)

assert(Matrix(grid: [[1, 2, 3], [4, 5, 6]]).shape == (2, 3))

print(A)
print(A[0])
print(A[col: 0])

let txtz = Matrix(rows: 3, cols: 3, initialValue: 0)
print(txtz)

let myEye = Matrix<Float>.eye(size: 6)
print(myEye)

let friendMatrix = Matrix(grid:
                            [[0, 1, 1, 0, 0, 0, 0, 0, 0, 0],  // user 0
                             [1, 0, 1, 1, 0, 0, 0, 0, 0, 0],  // user 1
                             [1, 1, 0, 1, 0, 0, 0, 0, 0, 0],  // user 2
                             [0, 1, 1, 0, 1, 0, 0, 0, 0, 0],  // user 3
                             [0, 0, 0, 1, 0, 1, 0, 0, 0, 0],  // user 4
                             [0, 0, 0, 0, 1, 0, 1, 1, 0, 0],  // user 5
                             [0, 0, 0, 0, 0, 1, 0, 0, 1, 0],  // user 6
                             [0, 0, 0, 0, 0, 1, 0, 0, 1, 0],  // user 7
                             [0, 0, 0, 0, 0, 0, 1, 1, 0, 1],  // user 8
                             [0, 0, 0, 0, 0, 0, 0, 0, 1, 0]]  // user 9
)

print(friendMatrix)

assert(friendMatrix[0, 2] == 1) // 0 and 2 are friends
assert(friendMatrix[0, 8] == 0) // 0 and 8 are not friends

let friendsOfFive = friendMatrix[5].enumerated()
    .filter { $0.1 == 1 }
    .map { $0.0 }

print(friendsOfFive)

let AA = Matrix(grid: [Vector(items: [1, 2]), Vector(items: [3, 4])])
print(AA)

//: [Next](@next)
