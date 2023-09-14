//
//  PieChartView.swift
//  OneSolution
//
//  Created by sreekanth reddy Tadi on 10/11/22.
//

import SwiftUI
import OneSolutionAPI

struct PieChartView: View {
    var arcDataValues: [ArcData]
    var colors: [Color]
    @State private var selectedIndex = -1
    
    var body: some View {
        ZStack {
            ForEach(0..<arcDataValues.count, id: \.self) { i in
                if selectedIndex == i {
                    Arc(
                        arcData: arcDataValues[i]
                    )
                    .pathColor(colors[i], 70)
                    .onTapGesture {
                        self.selectedIndex = -1
                    }
                } else {
                    Arc(
                        arcData: arcDataValues[i]
                    )
                    .pathColor(colors[i], 60)
                    .onTapGesture {
                        self.selectedIndex = i
                    }
                }
            }
        }
    }
}


struct PieChartView_preview: PreviewProvider {
    static var previews: some View {
        let chartValues = OneSolutionPieChartView.doubleValues(with: GraphData.staticValues)
        let arcData = ArcDataManager.createArcData(with: chartValues.0)
        PieChartView(arcDataValues: arcData, colors: chartValues.2)
    }
}
