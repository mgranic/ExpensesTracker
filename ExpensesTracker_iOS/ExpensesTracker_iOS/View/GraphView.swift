//
//  GraphView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 01.01.2024..
//

import SwiftUI
import Charts
import SwiftData

struct GraphView: View {
    @Environment(\.modelContext) var modelCtx
    @Binding var filteredExpenses: [Expense]      // expenses that are show in list to user and from which graph is drawn
    @StateObject var graphViewManager = GrapshViewManager()
    
    let priceCalculator = PriceCalculator()
    let expenseFilter = ExpenseFilter()
                                                    
    var chartType: ChartType                      // current chart type
    
    // if filtered data has to affect parrent view, then ExpenseManager has to be passed from parrent view 
    init(filteredExpenses: Binding<[Expense]> = Binding.constant([]), chartType: ChartType = ChartType.bar) {
        self._filteredExpenses = filteredExpenses
        self.chartType = chartType
    }
    
    var body: some View {
        VStack {
            Chart {
                if chartType == ChartType.bar {
                    ForEach(filteredExpenses) { expense in
                        BarMark(
                            x: .value("Category", expense.category),
                            y: .value("Price", expense.price)
                        )
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .top, endPoint: .bottom))
                    }
                } else {
                    // iterate total pricce per category
                    ForEach(graphViewManager.totalPricePerCategory, id: \.0) { pair in
                        if pair.1 > 0.0 {
                            SectorMark(
                                angle: .value("Price", pair.1),
                                innerRadius: .ratio(0.6),
                                angularInset: 1.0
                            )
                            .cornerRadius(6)
                            .foregroundStyle(by: .value("Category", pair.0))
                        }
                    }
                }
            }
            .onAppear {
                filteredExpenses = expenseFilter.getExpensesByDate(dateFrom: 1, dateCalcMethod: .month, showFilterAlert: &graphViewManager.showFilterAlert, modelContext: modelCtx)
                graphViewManager.resetPressedFields(2)
                graphViewManager.totalPricePerCategory = priceCalculator.totalPricePerCategory(filteredExpenses: filteredExpenses)
            }
            HStack {
                Button {
                    filteredExpenses = expenseFilter.getExpensesByDate(dateFrom: 1, dateCalcMethod: .day, showFilterAlert: &graphViewManager.showFilterAlert, modelContext: modelCtx)
                    if (chartType == ChartType.pie) {
                        graphViewManager.totalPricePerCategory = priceCalculator.totalPricePerCategory(filteredExpenses: filteredExpenses)
                    }
                    graphViewManager.resetPressedFields(0)
                } label: {
                    Text("1D")
                }
                .disabled(graphViewManager.intervalPressed[0])
                Spacer()
                Button {
                    filteredExpenses = expenseFilter.getExpensesByDate(dateFrom: 7, dateCalcMethod: .day, showFilterAlert: &graphViewManager.showFilterAlert, modelContext: modelCtx)
                    if (chartType == ChartType.pie) {
                        graphViewManager.totalPricePerCategory = priceCalculator.totalPricePerCategory(filteredExpenses: filteredExpenses)
                    }
                    graphViewManager.resetPressedFields(1)
                } label: {
                    Text("1W")
                }
                .disabled(graphViewManager.intervalPressed[1])
                Spacer()
                Button {
                    filteredExpenses = expenseFilter.getExpensesByDate(dateFrom: 1, dateCalcMethod: .month, showFilterAlert: &graphViewManager.showFilterAlert, modelContext: modelCtx)
                    if (chartType == ChartType.pie) {
                        graphViewManager.totalPricePerCategory = priceCalculator.totalPricePerCategory(filteredExpenses: filteredExpenses)
                    }
                    graphViewManager.resetPressedFields(2)
                } label: {
                    Text("1M")
                }
                .disabled(graphViewManager.intervalPressed[2])
                Spacer()
                Button {
                    filteredExpenses = expenseFilter.getExpensesByDate(dateFrom: 3, dateCalcMethod: .month, showFilterAlert: &graphViewManager.showFilterAlert, modelContext: modelCtx)
                    if (chartType == ChartType.pie) {
                        graphViewManager.totalPricePerCategory = priceCalculator.totalPricePerCategory(filteredExpenses: filteredExpenses)
                    }
                    graphViewManager.resetPressedFields(3)
                } label: {
                    Text("3M")
                }
                .disabled(graphViewManager.intervalPressed[3])
                Spacer()
                Button {
                    filteredExpenses = expenseFilter.getExpensesByDate(dateFrom: 1, dateCalcMethod: .year, showFilterAlert: &graphViewManager.showFilterAlert, modelContext: modelCtx)
                    if (chartType == ChartType.pie) {
                        graphViewManager.totalPricePerCategory = priceCalculator.totalPricePerCategory(filteredExpenses: filteredExpenses)
                    }
                    graphViewManager.resetPressedFields(4)
                } label: {
                    Text("1Y")
                }
                .disabled(graphViewManager.intervalPressed[4])
                Spacer()
                Button {
                    filteredExpenses = expenseFilter.getAllExpenses(modelContext: modelCtx)
                    if (chartType == ChartType.pie) {
                        graphViewManager.totalPricePerCategory = priceCalculator.totalPricePerCategory(filteredExpenses: filteredExpenses)
                    }
                    graphViewManager.resetPressedFields(5)
                } label: {
                    Text("MAX")
                }
                .disabled(graphViewManager.intervalPressed[5])
            }
            .alert(isPresented: $graphViewManager.showFilterAlert) {
                    Alert(title: Text("Failed to filter out expenses"))
            }
        }
        .background(Color.black)
    }
}
