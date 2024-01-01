//
//  ExpenseStatsView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 01.01.2024..
//

import SwiftUI

struct ExpenseStatsView: View {
    
    @State var xAxis: AxisValue = AxisValue.category
    @State var yAxis: AxisValue = AxisValue.price
    @State var chartType: ChartType = ChartType.bar
    
    
    var body: some View {
        VStack {
            Form {
                HStack(alignment: .center) {
                    Picker("X axis type:", selection: $xAxis) {
                        ForEach(AxisValue.allCases, id: \.self) { av in
                            Text("\(av.rawValue)").tag(av.rawValue)
                        }
                    }
                }
                HStack(alignment: .center) {
                    Picker("Y axis type:", selection: $yAxis) {
                        ForEach(AxisValue.allCases, id: \.self) { av in
                            Text("\(av.rawValue)").tag(av.rawValue)
                        }
                    }
                }
                HStack(alignment: .center) {
                    Picker("Chart type:", selection: $xAxis) {
                        ForEach(ChartType.allCases, id: \.self) { ct in
                            Text("\(ct.rawValue)").tag(ct.rawValue)
                        }
                    }
                }
            }
            .scrollDisabled(true)
            .frame(maxHeight: UIScreen.main.bounds.height * 0.2)
            
            GraphView()
        }
    }
}
