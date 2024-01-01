//
//  ExpenseStatsView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 01.01.2024..
//

import SwiftUI
import SwiftData
import Charts

struct ExpenseStatsView: View {
    @Query(sort: \Expense.timestamp) var expenses: [Expense]
    @StateObject var expenseManager: ExpenseManager = ExpenseManager()
    
    var body: some View {
        VStack {
            Chart {
                ForEach(expenseManager.filteredExpenses) { expense in
                    BarMark(
                        x: .value("Category", expense.category),
                        y: .value("Price", expense.price)
                    )
                }
            }
            .onAppear {
                expenseManager.resetExpensesFilter(expenses: expenses)
            }
            HStack {
                Button {
                    expenseManager.filterExpensesByDate(dateFrom: 1, dateCalcMethod: .day, expensesToFilter: expenses)
                } label: {
                    Text("1D")
                }
                Spacer()
                Button {
                    expenseManager.filterExpensesByDate(dateFrom: 7, dateCalcMethod: .day, expensesToFilter: expenses)
                } label: {
                    Text("1W")
                }
                Spacer()
                Button {
                    expenseManager.filterExpensesByDate(dateFrom: 1, dateCalcMethod: .month, expensesToFilter: expenses)
                } label: {
                    Text("1M")
                }
                Spacer()
                Button {
                    expenseManager.filterExpensesByDate(dateFrom: 4, dateCalcMethod: .month, expensesToFilter: expenses)
                } label: {
                    Text("3M")
                }
                Spacer()
                Button {
                    expenseManager.filterExpensesByDate(dateFrom: 1, dateCalcMethod: .year, expensesToFilter: expenses)
                } label: {
                    Text("1Y")
                }
                Spacer()
                Button {
                    expenseManager.resetExpensesFilter(expenses: expenses)
                } label: {
                    Text("MAX")
                }
            }
            .alert(isPresented: $expenseManager.showFilterAlert) {
                    Alert(title: Text("Failed to filter out expenses"))
            }
        }
    }
}

#Preview {
    ExpenseStatsView()
}
