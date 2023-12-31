//
//  ContentView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import SwiftUI
import Charts
import SwiftData

struct HomePageView: View {
    @Environment(\.modelContext) var modelCtx
    @Query(sort: \Expense.timestamp) var expenses: [Expense]
    
    @State var showCreateExpenseSheet: Bool = false
    @StateObject var expenseManager: ExpenseManager = ExpenseManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    showCreateExpenseSheet.toggle()
                }) {
                    Text("Add expense")
                    Image(systemName: "plus.circle.fill")
                }
                .onAppear(perform: {
                    expenseManager.resetExpensesFilter(expenses: expenses)
                })
                .sheet(isPresented: $showCreateExpenseSheet) {  // create expense sheet
                    AddExpenseView(isPresentSheet:$showCreateExpenseSheet, filteredExpenses: $expenseManager.filteredExpenses)
                }
                Chart {
                    ForEach(expenseManager.filteredExpenses) { expense in
                        BarMark(
                            x: .value("Article", expense.category),
                            y: .value("Price", expense.price)
                        )
                    }
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
                List {
                    ForEach(expenseManager.filteredExpenses) { expense in
                        Text("\(expense.name) - \(expense.price, specifier: "%.2f")")
                            .onTapGesture {
                                // store selected expense into selectedExpense so that it can be edited
                                expenseManager.selectedExpense = expense
                            }
                    }
                }
                .sheet(item: $expenseManager.selectedExpense) { expense in // show edit expense sheet
                    EditExpenseView(selectedExpense: expense, dbId: expense.id, filteredExpenses: $expenseManager.filteredExpenses)
                }
            }
            .toolbar {
                Menu {
                    Text("Menu text 1")
                    Text("Menu text 2")
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                        .foregroundColor(.black)
                }
            }
        }
        .padding()
    }
}

#Preview {
    HomePageView()
}
