//
//  File.swift
//  OneSolution
//
//  Created by sreekanth reddy Tadi on 10/11/22.
//

import SwiftUI
import OneSolutionUtility
import OneSolutionAPI

struct OneSolutionPieChartRows: View {
    var colors: [Color]
    var names: [String]
    var values: [Double]
    
    var body: some View {
        HStack {
            ///for id we need to pass unique value
            ///double also a struct, no problem if we pass .self as id in ForEach
            ForEach(0..<values.count, id: \.self) { i in
                PieChartViewRow(
                    color: colors[i],
                    name: names[i],
                    value: values[i]
                )
            }
        }
    }
}

struct PieChartViewRow: View {
    var color: Color
    var name: String
    var value: Double
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(color)
                .frame(width: 10, height: 10)
            Spacer().frame(width: 5)
            Text("\(name) \(value.stringValue)")
                .bold()
                .font(.system(size: appFont12))
        }
    }
}

struct OneSolutionPieChartRowsPreviews: PreviewProvider {
    static var previews: some View {
        let doubleValues = OneSolutionPieChartView.doubleValues(with: GraphData.staticValues)
        let doubleValues1 = OneSolutionPieChartView.doubleValues(with: GraphData.staticValues1)
        let doubleValues2 = OneSolutionPieChartView.doubleValues(with: GraphData.staticValues2)
        VStack {
            OneSolutionPieChartRows(colors: doubleValues.2, names: doubleValues.1, values: doubleValues.0)
                .frame(height: 40)
            OneSolutionPieChartRows(colors: doubleValues1.2, names: doubleValues1.1, values: doubleValues1.0)
                .frame(height: 40)
            OneSolutionPieChartRows(colors: doubleValues2.2, names: doubleValues2.1, values: doubleValues2.0)
                .frame(height: 40)
        }
    }
}
