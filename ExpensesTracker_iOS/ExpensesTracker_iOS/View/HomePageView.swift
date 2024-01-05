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
    @State var charType: ChartType = ChartType.bar
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Total: \(expenseManager.totalMoneySpent, specifier: "%.2f")")
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(.purple)
                    .onAppear(perform: {
                        expenseManager.resetExpensesFilter(expenses: expenses)
                        let settingsManager = SettingManager()
                        charType = settingsManager.getDefaultChart()
                        expenseManager.getTotalSpent()
                    })
                Button(action: {
                    showCreateExpenseSheet.toggle()
                }) {
                    Text("Add expense")
                    Image(systemName: "plus.circle.fill")
                }
                .sheet(isPresented: $showCreateExpenseSheet) {  // create expense sheet
                    AddExpenseView(isPresentSheet:$showCreateExpenseSheet, expenseManager: expenseManager)
                }
                // need to pass _expenseManager here because same filtered values are used to filter expenses list shown
                // bellow the graph
                GraphView(expenseManager: _expenseManager, chartType: charType)
                
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
                    EditExpenseView(dbId: expense.id, expenseManager: expenseManager)
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
