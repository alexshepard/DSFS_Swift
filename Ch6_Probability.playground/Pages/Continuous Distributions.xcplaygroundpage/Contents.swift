import Cocoa

extension FloatingPoint {
    /// standard uniform distribution pdf
    func uniformPdf() -> Self {
        return uniformPdfIn(range: 0..<1)
    }
    
    func uniformPdfIn(range: Range<Self>) -> Self {
        if 0 <= range.lowerBound && self < range.upperBound {
            return 1 / (range.upperBound - range.lowerBound)
        } else {
            return 0
        }
    }
    
    /// standard uniform distribution cdf
    func uniformCdf() -> Self {
        return uniformCdfIn(range: 0..<1)
    }
    
    func uniformCdfIn(range: Range<Self>) -> Self {
        if self < range.lowerBound { return Self(0) }
        if self >= range.upperBound { return Self(1) }
        return (self - range.lowerBound) / (range.upperBound - range.lowerBound)
    }
}

let x = Float(0.5)
print("the uniform pdf of \(x) is \(x.uniformPdf())")
print("the uniform pdf in range(0,1) of \(x) is \(x.uniformPdfIn(range: 0..<1))")
print("the uniform cdf of \(x) is \(x.uniformCdf())")
print("the uniform cdf in range(0,1) of \(x) is \(x.uniformCdfIn(range: 0..<1))")

print()

let y = Float.random(in: 0..<1)
print("the uniform pdf of \(y) is \(y.uniformPdf())")
print("the uniform pdf in range(0,1) of \(x) is \(y.uniformPdfIn(range: 0..<1))")
print("the uniform cdf of \(y) is \(y.uniformCdf())")
print("the uniform cdf in range(0,1) of \(y) is \(y.uniformCdfIn(range: 0..<1))")
print("the uniform cdf in range(0,3) of \(y) is \(y.uniformCdfIn(range: 0..<3))")

