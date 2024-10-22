import Foundation

struct Triangle {
    var sides : [Double?]
    var angles : [Double?]
    var triangleSolved : Bool
    var propertiesCalculated : Bool = false
    
    var area : Double? = nil
    var perimeter : Double? = nil
    var semiperimeter : Double? = nil
    var heights : [Double]? = nil
    var medians : [Double]? = nil
    var inRadius : Double? = nil
    var circumRadius : Double? = nil
    
    var name : String = "Triangle #1"
    
    var values = [Double]()
    
    init(s1: Double?, s2: Double?, s3: Double?, a1: Double?, a2: Double?, a3: Double?, solved: Bool = false, mode: String = "DEG") {
        sides = [s1, s2, s3]
        angles = [a1, a2, a3].map {
            if $0 != nil && mode == "DEG" {return ($0! * PI)/180}
            return $0
        }
        triangleSolved = solved
    }
    
    init(sides: [Double?], angles: [Double?], solve: Bool = true, name : String = "Triangle #1") {
        self.sides = sides
        self.angles = angles
        triangleSolved = solve
        self.name = name 
    }
    
    func createDescription() -> String? {
        var angleDescription = ""
        var sideDescription = ""
        
        if triangleSolved {
            if angles.contains(PI/2) {
                angleDescription = "Right"
            }
            else if angles.contains(where: {$0! > PI/2}) {
                angleDescription = "Obtuse"
            }
            else if angles.allSatisfy({$0 == PI/3}) {
                return "Equaliteral Triangle"
            }
            else {
                angleDescription = "Acute"
            }
            
            if (sides[0] == sides[1])||(sides[1] == sides[2])||(sides[2] == sides[0]) {
                sideDescription = "Isosceles"
            } else {
                sideDescription = "Scalene"
            }
            
            return "\(angleDescription) \(sideDescription) Triangle"
        }
        return nil
    }
    
    mutating func calcDetails() {
        if triangleSolved {
            area = 0.5 * sides[0]! * sides[1]! * sin(angles[2]!)
            perimeter = sides[0]! + sides[1]! + sides[2]!
            semiperimeter = perimeter! / 2
            heights = sides.map {(2 * area!)/$0!}
            medians = []
            medians!.append(sqrt(((2*sides[1]!*sides[1]!)+(2*sides[2]!*sides[2]!)-(sides[0]!*sides[0]!))/4))
            medians!.append(sqrt(((2*sides[0]!*sides[0]!)+(2*sides[2]!*sides[2]!)-(sides[1]!*sides[1]!))/4))
            medians!.append(sqrt(((2*sides[1]!*sides[1]!)+(2*sides[0]!*sides[0]!)-(sides[2]!*sides[2]!))/4))
            inRadius = area! / semiperimeter!
            circumRadius = sides[0]!/(2*sin(angles[0]!))
            propertiesCalculated = true
            values = [sides[0]!, sides[1]!, sides[2]!, angles[0]!, angles[1]!, angles[2]!, area!, perimeter!, semiperimeter!, heights![0], heights![1], heights![2], medians![0], medians![1], medians![2], inRadius!, circumRadius!]
            
        }
    }
    
    func printTriangle() {
        if triangleSolved {
            print("Side A = \(sides[0]!) Side B = \(sides[1]!) Side C = \(sides[2]!)\n")
            print("Angle A = \(angles[0]!) Angle B = \(angles[1]!) Angle C = \(angles[2]!)\n")
            if propertiesCalculated {
                print("Area = \(area!) Perimeter = \(perimeter!) Semiperimeter = \(semiperimeter!)\n")
                print("Height A = \(heights![0]) Height B = \(heights![1]) Height C = \(heights![2])\n")
                print("Median A = \(medians![0]) Median B = \(medians![1]) Median C = \(medians![2])\n")
                print("Inradius = \(inRadius!) Circumradius = \(circumRadius!)\n")
                
            }
        }
    }
    
}
