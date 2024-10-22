import Foundation

func solveSSS(sides: [Double?]) -> [Double] {
    var tempSides = sides
    var index = 0
    var newAngles = [Double]()
    while index < sides.count {
        let aSide = tempSides.remove(at: index)!
        let side1 = tempSides[0]!
        let side2 = tempSides[1]!
        let angle = acos(((side1*side1)+(side2*side2)-(aSide*aSide))/(2*side1*side2))
        newAngles.insert(angle, at: index)
        tempSides.insert(aSide, at: index)
        index += 1
    }
    return newAngles
}

func solveSAS(sides: [Double?], angles: [Double?]) -> [[Double?]]{
    var newSides = sides
    let includedIndex = angles.firstIndex {$0 != nil}!
    let includedAngle = angles[includedIndex]!
    let givenSides = sides.filter {$0 != nil}
    newSides[includedIndex] = solveIncludedSide(iAngle: includedAngle, side1: givenSides[0]!, side2: givenSides[1]!)
    var newAngles = solveSSS(sides: newSides)
    newAngles[includedIndex] = includedAngle
    return [newSides, newAngles]
}

func solveSSA(sides: [Double?], angles: [Double?], matchingIndex: Int) -> [[Double?]]? {
    var newSides = sides
    var newAngles = angles
    
    let matchingSide = newSides[matchingIndex]!
    let matchingAngle = newAngles[matchingIndex]!
    let finalIndex = newSides.firstIndex {$0 == nil}!
    var otherIndex = newSides.firstIndex {$0 != nil}!
    otherIndex = (otherIndex == matchingIndex) ? newSides.lastIndex {$0 != nil}! : otherIndex
    let otherSide = newSides[otherIndex]!
    let altitude = otherSide * sin(matchingAngle)
    
    if matchingAngle < PI/2 {
        if altitude < matchingSide && matchingSide < otherSide {
            var newSides2 = newSides
            var newAngles2 = newAngles
            
            let otherAngle = solveAngleWithMatching(mSide: matchingSide, mAngle:  matchingAngle, oSide: otherSide)
            newAngles[otherIndex] = otherAngle
            newAngles2[otherIndex] = PI - otherAngle
            
            newAngles[finalIndex] = solveFinalAngle(angles: newAngles)
            newAngles2[finalIndex] = solveFinalAngle(angles: newAngles2)
            
            newSides[finalIndex] = solveSideWithMatching(mSide: matchingSide, mAngle: matchingAngle, oAngle: newAngles[finalIndex]!)
            newSides2[finalIndex] = solveSideWithMatching(mSide: matchingSide, mAngle: matchingAngle, oAngle: newAngles2[finalIndex]!)
            
            return [newSides, newAngles, newSides2, newAngles2]
        
        } else if matchingSide < altitude {return nil}
    } else {if matchingSide < otherSide {return nil}}
    
    newAngles[otherIndex] = solveAngleWithMatching(mSide: matchingSide, mAngle: matchingAngle, oSide: otherSide)
    newAngles[finalIndex] = solveFinalAngle(angles: newAngles)
    newSides[finalIndex] = solveSideWithMatching(mSide: matchingSide, mAngle: matchingAngle, oAngle: newAngles[finalIndex]!)
    
    return [newSides, newAngles]
}

func solveAAS (sides: [Double?], angles: [Double?]) -> [[Double?]] {
    var newAngles = angles
    newAngles[newAngles.firstIndex {$0 == nil}!] = solveFinalAngle(angles: newAngles)
    var newSides = sides
    var index = 0
    let matchingIndex = findMatchingPair(sides: sides, angles: newAngles)!
    while index < sides.count {
        if newSides[index] == nil {
            newSides[index] = solveSideWithMatching(mSide: newSides[matchingIndex]!, mAngle: newAngles[matchingIndex]!, oAngle: newAngles[index]!)
        }
        index += 1
    }
    return [newSides, newAngles]
}

func solveIncludedSide(iAngle: Double, side1: Double, side2: Double) -> Double {
    return sqrt(side1*side1+side2*side2-(2*side1*side2*cos(iAngle)))
}

func solveAngleWithMatching(mSide: Double, mAngle: Double, oSide: Double) -> Double {
    return asin((oSide * sin(mAngle))/mSide)
}

func solveSideWithMatching(mSide: Double, mAngle: Double, oAngle: Double) -> Double {
    return (mSide*sin(oAngle))/sin(mAngle)
}

func solveFinalAngle(angles: [Double?]) -> Double {
    return angles.reduce(PI) {$1 != nil ? $0 - $1! : $0}
}


func findMatchingPair(sides: [Double?], angles: [Double?]) -> Int? {
    var index = 0
    while index < sides.count {
        if sides[index] != nil && angles[index] != nil {
            return index
        }
        index += 1
    }
    return nil
}
