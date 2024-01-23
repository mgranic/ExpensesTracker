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
    
    @State var avgPerCategory: Double = 0.0
    @State var avgInterval: ExpenseInterval = ExpenseInterval.day
    @State var avgCategory: String = "all"
    
    @State var totalPerCategory: Double = 0.0
    @State var totalInterval: String = "day"
    @State var totalCategory: String = "all"
    
    let priceCalculator = PriceCalculator()
    
    
    var body: some View {
        //VStack {
            ScrollView {
                VStack {
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
                    }
                    .frame(minHeight: UIScreen.main.bounds.height * 0.2, maxHeight: UIScreen.main.bounds.height * 0.2)
                    VStack {
                        GraphView(filteredExpenses: $filteredExpenses, chartType: chartType)
                    }
                    .frame(minHeight: UIScreen.main.bounds.height * 0.5, maxHeight: UIScreen.main.bounds.height * 0.5)
                        
                    VStack {
                        Form {
                            Section(header: Text("Avarage spending per category")) {
                                Picker("Interval:", selection: $avgInterval) {
                                    ForEach(ExpenseInterval.allCases, id: \.self) { ct in
                                        Text("\(ct.rawValue)").tag(ct.rawValue)
                                    }
                                }
                                .onChange(of: avgInterval, {
                                    avgPerCategory = priceCalculator.totalPricePerCategoryPerInterval(modelCtx: modelCtx, category: avgCategory, interval: avgInterval)
                                })
                                
                                Picker("Category:", selection: $avgCategory) {
                                    ForEach(Category.allCases, id: \.self) { ct in
                                        Text("\(ct.rawValue)").tag(ct.rawValue)
                                    }
                                    Text("all").tag("all")
                                }
                                .onChange(of: avgCategory, {
                                    avgPerCategory = priceCalculator.totalPricePerCategoryPerInterval(modelCtx: modelCtx, category: avgCategory, interval: avgInterval)
                                })
                                Text("Avg: \(avgPerCategory, specifier: "%.2f") €")
                            }
                        }
                        .scrollDisabled(true)
                        .onAppear {
                            avgPerCategory = priceCalculator.totalPricePerCategoryPerInterval(modelCtx: modelCtx, category: avgCategory, interval: avgInterval)
                        }
                    }
                    .frame(minHeight: UIScreen.main.bounds.height * 0.2, maxHeight: UIScreen.main.bounds.height * 0.2)
                    
                    VStack {
                        Form {
                            Section(header: Text("Total spending per category")) {
                                Picker("Interval:", selection: $totalInterval) {
                                    ForEach(ExpenseInterval.allCases, id: \.self) { ct in
                                        Text("\(ct.rawValue)").tag(ct.rawValue)
                                    }
                                }
                                .onChange(of: totalInterval, {
                                    totalPerCategory = priceCalculator.totalPricePerCategoryInInterval(modelCtx: modelCtx, category: totalCategory, interval: ExpenseInterval(rawValue: totalInterval) ?? ExpenseInterval.week)
                                })
                                Picker("Category:", selection: $totalCategory) {
                                    ForEach(Category.allCases, id: \.self) { ct in
                                        Text("\(ct.rawValue)").tag(ct.rawValue)
                                    }
                                    Text("all").tag("all")
                                }
                                .onChange(of: totalCategory, {
                                    totalPerCategory = priceCalculator.totalPricePerCategoryInInterval(modelCtx: modelCtx, category: totalCategory, interval: ExpenseInterval(rawValue: totalInterval) ?? ExpenseInterval.week)
                                })
                                Text("Total: \(totalPerCategory, specifier: "%.2f") €")
                            }
                        }
                        .scrollDisabled(true)
                        .onAppear {
                            totalPerCategory = priceCalculator.totalPricePerCategoryInInterval(modelCtx: modelCtx, category: totalCategory, interval: ExpenseInterval(rawValue: totalInterval) ?? ExpenseInterval.week)
                        }
                    }
                    .frame(minHeight: UIScreen.main.bounds.height * 0.2, maxHeight: UIScreen.main.bounds.height * 0.2)
                }
            }
        //}
        //.frame(maxHeight: UIScreen.main.bounds.height)
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
