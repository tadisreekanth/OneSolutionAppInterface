//
//  OneSolutionPieChartView.swift
//  OneSolution
//
//  Created by sreekanth reddy Tadi on 26/10/22.
//

import SwiftUI
import OneSolutionAPI

struct OneSolutionPieChartView: View {
    var graphData: GraphData?
    
    var body: some View {
        let chartValues = OneSolutionPieChartView.doubleValues(with: self.graphData)
        GeometryReader { geometry in
            VStack(spacing: 20) {
                //pie chart
                PieChartView(
                    arcDataValues: ArcDataManager.createArcData(with: chartValues.0),
                    colors: chartValues.2
                )
                                
                //piechart details
                OneSolutionPieChartRows(
                    colors: chartValues.2,
                    names: chartValues.1,
                    values: chartValues.0
                )
                .frame(height: 40, alignment: .center)
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height)
        }
    }
}

extension OneSolutionPieChartView {
    
    static func doubleValues(with graphData: GraphData?) -> ([Double], [String] , [Color]) {
        var values = [Double]()
        var names = [String]()
        var colors = [Color]()
        if let value = graphData?.fOpenCount?.doubleValue {
            values.append(value)
            names.append("Open") //(graphData?.fOpenCount?.stringValue ?? "")
            colors.append(Color.blue)
        }
        if let value = graphData?.fClosedCount?.doubleValue {
            values.append(value)
            names.append("Closed") //(graphData?.fClosedCount?.stringValue ?? "")
            colors.append(Color.green)
        }
        if let value = graphData?.fHold?.doubleValue {
            values.append(value)
            names.append("Hold") //(graphData?.fHold?.stringValue ?? "")
            colors.append(Color.yellow)
        }
        return (values, names, colors)
    }
}


struct OneSolutionPieChartView_swift_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
        OneSolutionPieChartView(graphData: GraphData(fHold: 7711, fOpenCount: 159737, fClosedCount: 7711))
                .frame(width: geometry.size.width, height: 350)
        }
    }
}
