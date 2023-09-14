//
//  ArcData.swift
//  OneSolution
//
//  Created by sreekanth reddy Tadi on 13/11/22.
//

import SwiftUI

struct ArcData {
    var startAngle, endAngle: Angle
    var value: Double
    var clockWise: Bool = false
    ///between 0 to 1
    var innerCircleRadius: CGFloat = 0.7
}

class ArcDataManager {
    
    static func createArcData(with values: [Double],
                              clockWise: Bool = false,
                              innerCircleRadius: CGFloat = 0.7) -> [ArcData] {
        var arcDataValues = [ArcData]()
        let sum = values.reduce(0.0, +)
        for i in 0..<values.count {
            let startAngleDegrees = i == 0 ? 0 : angle(at: i-1,
                                                       in: values,
                                                       with: sum,
                                                       clockWise: clockWise)
            let endAngleDegrees = i == values.count-1 ? 0 : angle(at: i,
                                                                  in: values,
                                                                  with: sum,
                                                                  clockWise: clockWise)
            let startAngle: Angle = .degrees(startAngleDegrees)
            let endAngle: Angle = .degrees(endAngleDegrees)
            
            arcDataValues.append(ArcData(startAngle: startAngle,
                                         endAngle: endAngle,
                                         value: values[i],
                                         clockWise: clockWise,
                                         innerCircleRadius: innerCircleRadius))
        }
        return arcDataValues
    }
    
    static private func angle(at position: Int,
                              in values: [Double],
                              with sum: Double,
                              clockWise: Bool = false) -> Double {
        var value = 0.0
        var pos = position
        while pos >= 0 {
            value = value + (values[pos]/sum)
            pos -= 1
        }
        return clockWise ? -value*360 : value*360
    }
}
