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
    @State var totalPricePerCategory: [(String, Double)] = []
    @Binding var filteredExpenses: [Expense]   // expenses that are show in list to user and from which graph is drawn
    @State var showFilterAlert: Bool = false      // if true, show alert for bad filtering
    @State var intervalPressed: [Bool] = [false, false, false, false, false, false]
    @State var lastButtonPressed: Int = 0
    
    let priceCalculator = PriceCalculator()
    let expenseFilter = ExpenseFilter()
                                                    
    var chartType: ChartType
    
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
                expenseFilter.resetExpensesFilter(filteredExpenses: &filteredExpenses, expenses: expenses)
                totalPricePerCategory = priceCalculator.totalPricePerCategory(filteredExpenses: filteredExpenses)
            }
            HStack {
                Button {
                    expenseFilter.filterExpensesByDate(dateFrom: 1, dateCalcMethod: .day, expensesToFilter: expenses, filteredExpenses: &filteredExpenses, showFilterAlert: &showFilterAlert)
                    if (chartType == ChartType.pie) {
                        totalPricePerCategory = priceCalculator.totalPricePerCategory(filteredExpenses: filteredExpenses)
                    }
                    resetPressedFields(0)
                } label: {
                    Text("1D")
                }
                .disabled(intervalPressed[0])
                Spacer()
                Button {
                    expenseFilter.filterExpensesByDate(dateFrom: 7, dateCalcMethod: .day, expensesToFilter: expenses, filteredExpenses: &filteredExpenses, showFilterAlert: &showFilterAlert)
                    if (chartType == ChartType.pie) {
                        totalPricePerCategory = priceCalculator.totalPricePerCategory(filteredExpenses: filteredExpenses)
                    }
                    resetPressedFields(1)
                } label: {
                    Text("1W")
                }
                .disabled(intervalPressed[1])
                Spacer()
                Button {
                    expenseFilter.filterExpensesByDate(dateFrom: 1, dateCalcMethod: .month, expensesToFilter: expenses, filteredExpenses: &filteredExpenses, showFilterAlert: &showFilterAlert)
                    if (chartType == ChartType.pie) {
                        totalPricePerCategory = priceCalculator.totalPricePerCategory(filteredExpenses: filteredExpenses)
                    }
                    resetPressedFields(2)
                } label: {
                    Text("1M")
                }
                .disabled(intervalPressed[2])
                Spacer()
                Button {
                    expenseFilter.filterExpensesByDate(dateFrom: 3, dateCalcMethod: .month, expensesToFilter: expenses, filteredExpenses: &filteredExpenses, showFilterAlert: &showFilterAlert)
                    if (chartType == ChartType.pie) {
                        totalPricePerCategory = priceCalculator.totalPricePerCategory(filteredExpenses: filteredExpenses)
                    }
                    resetPressedFields(3)
                } label: {
                    Text("3M")
                }
                .disabled(intervalPressed[3])
                Spacer()
                Button {
                    expenseFilter.filterExpensesByDate(dateFrom: 1, dateCalcMethod: .year, expensesToFilter: expenses, filteredExpenses: &filteredExpenses, showFilterAlert: &showFilterAlert)
                    if (chartType == ChartType.pie) {
                        totalPricePerCategory = priceCalculator.totalPricePerCategory(filteredExpenses: filteredExpenses)
                    }
                    resetPressedFields(4)
                } label: {
                    Text("1Y")
                }
                .disabled(intervalPressed[4])
                Spacer()
                Button {
                    expenseFilter.resetExpensesFilter(filteredExpenses: &filteredExpenses, expenses: expenses)
                    if (chartType == ChartType.pie) {
                        totalPricePerCategory = priceCalculator.totalPricePerCategory(filteredExpenses: filteredExpenses)
                    }
                    resetPressedFields(5)
                } label: {
                    Text("MAX")
                }
                .disabled(intervalPressed[5])
            }
            .alert(isPresented: $showFilterAlert) {
                    Alert(title: Text("Failed to filter out expenses"))
            }
        }
        .background(Color.black)
    }
    
    func resetPressedFields(_ buttonPressed: Int) {
        intervalPressed[lastButtonPressed] = false
        intervalPressed[buttonPressed] = true
        lastButtonPressed = buttonPressed
    }
}
