//
//  ArcView.swift
//  OneSolution
//
//  Created by sreekanth reddy Tadi on 10/11/22.
//

import SwiftUI
import OneSolutionAPI

struct Arc: Shape {
    var arcData: ArcData
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.height/2),
                    radius: rect.size.width*0.5*arcData.innerCircleRadius,
                    startAngle: arcData.startAngle,
                    endAngle: arcData.endAngle,
                    clockwise: arcData.clockWise)
        return path
    }
}

struct Arc_preview: PreviewProvider {
    static var previews: some View {
        
        let chartValues = OneSolutionPieChartView.doubleValues(with: GraphData.staticValues)
        
        let arcData = ArcDataManager.createArcData(with: chartValues.0)
        
        Arc(
            arcData: arcData[2]
        )
        .pathColor(.orange, 70)
    }
}
