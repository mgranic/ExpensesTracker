//
//  ExpenseStatsView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 01.01.2024..
//

import SwiftUI

struct ExpenseStatsView: View {
    @Environment(\.modelContext) var modelCtx
    @State var chartType: ChartType = ChartType.bar
    @State var filteredExpenses: [Expense] = []
    
    
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
                Button("Set default chart type") {
                    let settingsManager = SettingManager()
                    settingsManager.setDefaultChart(chartType: chartType)
                }
                .buttonStyle(.borderedProminent)
            }
            .scrollDisabled(true)
            .frame(maxHeight: UIScreen.main.bounds.height * 0.2)
            
            GraphView(filteredExpenses: $filteredExpenses, chartType: chartType)
        }
        .toolbar {
            NavigationLink(destination: SearchView(modelCtx: modelCtx)) {
                Image(systemName: "magnifyingglass")
            }
            Menu {
                NavigationLink(destination: HomePageView()) {
                    Text("Home Page")
                }
                NavigationLink(destination: ScheduleExpenseView()) {
                    Text("Schedule expense")
                }
                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                }
            } label: {
                Label("Menu", systemImage: "ellipsis.circle")
                    .foregroundColor(.black)
            }
        }
        .background(Color.black)
    }
}
