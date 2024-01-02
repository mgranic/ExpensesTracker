//
//  ExpenseStatsView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 01.01.2024..
//

import SwiftUI

struct ExpenseStatsView: View {
    
    @State var chartType: ChartType = ChartType.bar
    
    
    var body: some View {
        VStack {
            Form {
                HStack(alignment: .center) {
                    Picker("Chart type:", selection: $chartType) {
                        ForEach(ChartType.allCases, id: \.self) { ct in
                            Text("\(ct.rawValue)").tag(ct.rawValue)
                        }
                    }
                }
            }
            .scrollDisabled(true)
            .frame(maxHeight: UIScreen.main.bounds.height * 0.2)
            
            GraphView(chartType: chartType)
        }
    }
}
