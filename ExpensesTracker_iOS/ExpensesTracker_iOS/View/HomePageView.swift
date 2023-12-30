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
    //@State var selectedExpense: Expense?
    //@State var filteredExpenses: [Expense] = []
    
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
                    //try! filteredExpenses = expenses.filter(Expense.searchByDate(dateFrom: 0, dateCalcMethod: .max))
                })
                .sheet(isPresented: $showCreateExpenseSheet) {
                    AddExpenseView(isPresentSheet:$showCreateExpenseSheet, filteredExpenses: $expenseManager.filteredExpenses, selectedExpense: Expense(price: 0.0, name: "", category: Category.none.rawValue, timestamp: Date()))
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
                        //try! filteredExpenses = expenses.filter(Expense.searchByDate(dateFrom: 1, dateCalcMethod: .day))
                        expenseManager.filterExpensesByDate(dateFrom: 1, dateCalcMethod: .day, expensesToFilter: expenses)
                    } label: {
                        Text("1D")
                    }
                    Spacer()
                    Button {
                        //try! filteredExpenses = expenses.filter(Expense.searchByDate(dateFrom: 7, dateCalcMethod: .day))
                        expenseManager.filterExpensesByDate(dateFrom: 7, dateCalcMethod: .day, expensesToFilter: expenses)
                    } label: {
                        Text("1W")
                    }
                    Spacer()
                    Button {
                        //try! filteredExpenses = expenses.filter(Expense.searchByDate(dateFrom: 1, dateCalcMethod: .month))
                        expenseManager.filterExpensesByDate(dateFrom: 1, dateCalcMethod: .month, expensesToFilter: expenses)
                    } label: {
                        Text("1M")
                    }
                    Spacer()
                    Button {
                        //try! filteredExpenses = expenses.filter(Expense.searchByDate(dateFrom: 3, dateCalcMethod: .month))
                        expenseManager.filterExpensesByDate(dateFrom: 4, dateCalcMethod: .month, expensesToFilter: expenses)
                    } label: {
                        Text("3M")
                    }
                    Spacer()
                    Button {
                        //try! filteredExpenses = expenses.filter(Expense.searchByDate(dateFrom: 1, dateCalcMethod: .year))
                        expenseManager.filterExpensesByDate(dateFrom: 1, dateCalcMethod: .year, expensesToFilter: expenses)
                    } label: {
                        Text("1Y")
                    }
                    Spacer()
                    Button {
                        //try! filteredExpenses = expenses.filter(Expense.searchByDate(dateFrom: 0, dateCalcMethod: .max))
                        expenseManager.resetExpensesFilter(expenses: expenses)
                    } label: {
                        Text("MAX")
                    }
                }
                List {
                    ForEach(expenseManager.filteredExpenses) { expense in
                        Text("\(expense.name) - \(expense.price, specifier: "%.2f")")
                            .onTapGesture {
                                expenseManager.selectedExpense = expense
                            }
                    }
                }
                .sheet(item: $expenseManager.selectedExpense) { expense in
                    EditExpenseView(selectedExpense: expense, dbId: expense.id, filteredExpenses: $expenseManager.filteredExpenses)
                }
            }
            .toolbar {
                Menu {
                    // TODO: change Text into NavigationLink to proper Views
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
