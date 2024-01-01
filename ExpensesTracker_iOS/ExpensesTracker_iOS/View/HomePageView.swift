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
                // need to pass _expenseManager here because same filtered values are used to filter expenses list shown
                // bellow the graph
                GraphView(expenseManager: _expenseManager)
                
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
                    NavigationLink(destination: ExpenseStatsView()) {
                        Text("Expense Stats")
                    }
                    NavigationLink(destination: SettingsView()) {
                        Text("Settings")
                    }
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
