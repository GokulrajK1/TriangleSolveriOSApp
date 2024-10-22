import Foundation

enum TriangleErrors : Error {
    case SidesInequalityFailed
    case InvalidAngles
    case ExcessInputs
    case TriangleDNE
    case SideNotProvided
    case NotEnoughInputs
}

let PI = Double.pi

struct SolverModel {
    var triangle : Triangle?
    var triangle2 : Triangle?
    
    let modes = ["DEG", "RAD"]
    var mode : String = "DEG"
    
    func formatValue(currentTriangle: Triangle, index : Int) -> String {
        let values = currentTriangle.values
        let value = values[index]
        let valString = formatDecimal(String(format: "%.4f", value))
        if [3,4,5].contains(index) {
            let decimalValString = formatDecimal(String(format: "%.4f", (value*180)/PI))
            if mode == "DEG" {
                return "\(decimalValString)° = \(valString) rad"
            } else {
                return "\(valString) rad = \(decimalValString)°"
            }
        }
        return valString
    }
    
    private func formatDecimal(_ valString: String) -> String {
        var newString = valString
        if newString.contains(".") && newString.last == "0" {
            while newString.contains(".") {
                newString.removeLast()
                if newString.last != "0" && newString.last != "." {
                    break
                }
            }
        }
        return newString
    }
    
    mutating func solveTriangle(with textValues : [String?]) throws {
        createTriangle(with: textValues)
        if let sides = triangle?.sides, let angles = triangle?.angles {
            if shouldThrowInvalidAngles(angles: angles) {throw TriangleErrors.InvalidAngles}
            let numOfSides = sides.reduce(0) {$1 != nil ? $0 + 1 : $0}
            let numOfAngles = angles.reduce(0) {$1 != nil ? $0 + 1 : $0}
            if numOfSides + numOfAngles > 3 {
                throw TriangleErrors.ExcessInputs
            } else if numOfSides == 3 { // SSS CASE
                if shouldThrowSidesInequalityFailed(sides: sides) {throw TriangleErrors.SidesInequalityFailed}
                let newAngles = solveSSS(sides: sides)
                triangle = Triangle(sides: sides, angles: newAngles)
            } else if numOfSides == 2 && numOfAngles == 1 {
                if let indexOfPair = findMatchingPair(sides: sides, angles: angles) { // SSA CASE
                    if let answers = solveSSA(sides: sides, angles: angles, matchingIndex: indexOfPair) {
                        if answers.count == 2 {
                            triangle = Triangle(sides: answers[0], angles: answers[1])
                        } else {
                            triangle = Triangle(sides: answers[0], angles: answers[1])
                            triangle2 = Triangle(sides: answers[2], angles: answers[3], name: "Triangle #2")
                        }
                    } else {
                        throw TriangleErrors.TriangleDNE
                    }
                } else { // SAS CASE
                    let answers = solveSAS(sides: sides, angles: angles)
                    triangle = Triangle(sides: answers[0], angles: answers[1])
                }
            } else if numOfSides == 1 && numOfAngles == 2 { // AAS Case
                let answers = solveAAS(sides: sides, angles: angles)
                triangle = Triangle(sides: answers[0], angles: answers[1])
            } else if numOfAngles == 3 {
                throw TriangleErrors.SideNotProvided
            } else {
                throw TriangleErrors.NotEnoughInputs
            }
        calcDetailsForTriangles()
        }
    }
    
    func printTriangles() {
        triangle?.printTriangle()
        triangle2?.printTriangle()
    }
    
    private mutating func createTriangle(with textValues: [String?]) {
        var numValues = [Double?]()
        for value in textValues {
            numValues.append(Double(value ?? "a") ?? nil)
        }
        triangle = Triangle(s1: numValues[0], s2: numValues[1], s3: numValues[2], a1: numValues[3], a2: numValues[4], a3: numValues[5], solved: false, mode: mode)
        
    }
    
    private func shouldThrowSidesInequalityFailed(sides: [Double?]) -> Bool {
        for (index, side) in sides.enumerated() {
            var tempSides = sides
            tempSides.remove(at: index)
            let sumOf2 = tempSides.reduce(0) {$1!+$0}
            if side! >= sumOf2 {
                return true
            }
        }
        return false
    }
    
    private func shouldThrowInvalidAngles(angles: [Double?]) -> Bool {
        let sumOfAngles = angles.reduce(0) {$1 != nil ? $0 + $1! : $0}
        return sumOfAngles < PI ? false : true
    }
    
    private mutating func calcDetailsForTriangles() {
        triangle?.calcDetails()
        triangle2?.calcDetails()
    }
}
