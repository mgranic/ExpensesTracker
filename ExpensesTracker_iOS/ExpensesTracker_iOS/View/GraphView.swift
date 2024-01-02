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
    @Query(sort: \Expense.timestamp) var expenses: [Expense]
    @StateObject var expenseManager: ExpenseManager
    @State var totalPricePerCategory: [(String, Double)] = []
    
    @State var intervalPressed: [Bool] = [false, false, false, false, false, false]
    @State var lastButtonPressed: Int = 0
    
    var chartType: ChartType
    
    // if filtered data has to affect parrent view, then ExpenseManager has to be passed from parrent view 
    init(expenseManager: StateObject<ExpenseManager> = StateObject(wrappedValue: ExpenseManager()), chartType: ChartType = ChartType.bar) {
        self._expenseManager = expenseManager
        self.chartType = chartType
    }
    
    var body: some View {
        VStack {
            Chart {
                if chartType == ChartType.bar {
                    ForEach(expenseManager.filteredExpenses) { expense in
                        BarMark(
                            x: .value("Category", expense.category),
                            y: .value("Price", expense.price)
                        )
                    }
                } else {
                    // iterate total pricce per category
                    ForEach(totalPricePerCategory, id: \.0) { pair in
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
                expenseManager.resetExpensesFilter(expenses: expenses)
                totalPricePerCategory = expenseManager.totalPricePerCategory()
            }
            HStack {
                Button {
                    expenseManager.filterExpensesByDate(dateFrom: 1, dateCalcMethod: .day, expensesToFilter: expenses)
                    if (chartType == ChartType.pie) {
                        totalPricePerCategory = expenseManager.totalPricePerCategory()
                    }
                    resetPressedFields(0)
                } label: {
                    Text("1D")
                }
                .disabled(intervalPressed[0])
                Spacer()
                Button {
                    expenseManager.filterExpensesByDate(dateFrom: 7, dateCalcMethod: .day, expensesToFilter: expenses)
                    if (chartType == ChartType.pie) {
                        totalPricePerCategory = expenseManager.totalPricePerCategory()
                    }
                    resetPressedFields(1)
                } label: {
                    Text("1W")
                }
                .disabled(intervalPressed[1])
                Spacer()
                Button {
                    expenseManager.filterExpensesByDate(dateFrom: 1, dateCalcMethod: .month, expensesToFilter: expenses)
                    if (chartType == ChartType.pie) {
                        totalPricePerCategory = expenseManager.totalPricePerCategory()
                    }
                    resetPressedFields(2)
                } label: {
                    Text("1M")
                }
                .disabled(intervalPressed[2])
                Spacer()
                Button {
                    expenseManager.filterExpensesByDate(dateFrom: 4, dateCalcMethod: .month, expensesToFilter: expenses)
                    if (chartType == ChartType.pie) {
                        totalPricePerCategory = expenseManager.totalPricePerCategory()
                    }
                    resetPressedFields(3)
                } label: {
                    Text("3M")
                }
                .disabled(intervalPressed[3])
                Spacer()
                Button {
                    expenseManager.filterExpensesByDate(dateFrom: 1, dateCalcMethod: .year, expensesToFilter: expenses)
                    if (chartType == ChartType.pie) {
                        totalPricePerCategory = expenseManager.totalPricePerCategory()
                    }
                    resetPressedFields(4)
                } label: {
                    Text("1Y")
                }
                .disabled(intervalPressed[4])
                Spacer()
                Button {
                    expenseManager.resetExpensesFilter(expenses: expenses)
                    if (chartType == ChartType.pie) {
                        totalPricePerCategory = expenseManager.totalPricePerCategory()
                    }
                    resetPressedFields(5)
                } label: {
                    Text("MAX")
                }
                .disabled(intervalPressed[5])
            }
            .alert(isPresented: $expenseManager.showFilterAlert) {
                    Alert(title: Text("Failed to filter out expenses"))
            }
        }
    }
    
    func resetPressedFields(_ buttonPressed: Int) {
        intervalPressed[lastButtonPressed] = false
        intervalPressed[buttonPressed] = true
        lastButtonPressed = buttonPressed
    }
}
