import Foundation

public struct Matrix<T: FloatingPoint>: Equatable {
    private let rows: Int
    private let cols: Int
    public var items: [T]
    
    /// initializer for creating a matrix with an initial value
    public init(rows: Int, cols: Int, initialValue: T) {
        precondition(rows > 0)
        precondition(cols > 0)
        
        self.rows = rows
        self.cols = cols
        self.items = [T].init(repeating: initialValue, count: rows * cols)
    }
    
    /// initializer for creating a matrix from a rectangular list of lists
    public init(grid: [[T]]) {
        precondition(!grid.isEmpty, "Grid cannot be empty.")
        let lens = Set(grid.map { $0.count })
        precondition(lens.count == 1, "All rows in the grid must have the same size.")
        
        self.rows = grid.count
        self.cols = grid[0].count
        self.items = grid.flatMap { $0 }
    }
    
    public init(grid: [Vector<T>]) {
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
    
    public var shape: (Int, Int) {
        return (rows, cols)
    }
    
    private func indexIsValid(row: Int, col: Int) -> Bool {
        return row >= 0 && row < rows && col >= 0 && col < cols
    }
    
}

// indexing
extension Matrix {
    /// accessing and setting element by row and col
    public subscript(row: Int, col: Int) -> T {
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
    public subscript(row: Int) -> Vector<T> {
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
    public subscript(col colIndex: Int) -> Vector<T> {
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
    public static func zeros(rows: Int, cols: Int) -> Matrix {
        return Matrix(rows: rows, cols: cols, initialValue: 0)
    }
    
    /// Create a matrix of all ones.
    public static func ones(rows: Int, cols: Int) -> Matrix {
        return Matrix(rows: rows, cols: cols, initialValue: 1)
    }
    
    /// Create an identity matrix.
    public static func eye(size: Int) -> Matrix {
        let items: [T] = (0..<size*size).map {
            ($0 / size == $0 % size) ? 1 : 0
        }
        return Matrix(rows: size, cols: size, items: items)
    }
}

// Custom description for printing the matrix
extension Matrix: CustomStringConvertible {
    public var description: String {
        (0..<rows).map { row in
            self[row].map { item in
                String(describing: item)
            }.joined(separator: " ")
        }.joined(separator: "\n")
    }
}

