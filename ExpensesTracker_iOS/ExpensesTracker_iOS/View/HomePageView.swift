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
    @Environment(\.modelContext) var modelCtx
    @State var showCreateExpenseSheet: Bool = false
    @StateObject var expenseManager: ExpenseManager = ExpenseManager()
    @State var filteredExpenses: [Expense] = []   // expenses that are show in list to user and from which graph is drawn
    @State var selectedExpense: Expense?          // expense selected for edditing
    @State var showFilterAlert: Bool = false      // if true, show alert for bad filtering
    @State var charType: ChartType = ChartType.bar
    @State var totalMoneySpent: Double = 0.0
    let priceCalculator = PriceCalculator()
    let expenseFilter = ExpenseFilter()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Total: \(totalMoneySpent, specifier: "%.2f")")
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(.purple)
                    .onAppear(perform: {
                        expenseFilter.resetExpensesFilter(filteredExpenses: &filteredExpenses, expenses: expenses)
                        let settingsManager = SettingManager()
                        charType = settingsManager.getDefaultChart()
                        totalMoneySpent = priceCalculator.getTotalSpent()
                    })
                Button(action: {
                    showCreateExpenseSheet.toggle()
                }) {
                    Text("Add expense")
                        .font(.system(.title2, design: .rounded))
                    Image(systemName: "plus.circle.fill")
                }
                .sheet(isPresented: $showCreateExpenseSheet, onDismiss: {totalMoneySpent = priceCalculator.getTotalSpent()}) {  // create expense sheet
                    AddExpenseView(isPresentSheet:$showCreateExpenseSheet, filteredExpenses: $filteredExpenses)
                }
                // need to pass _expenseManager here because same filtered values are used to filter expenses list shown
                // bellow the graph
                GraphView(filteredExpenses: $filteredExpenses, chartType: charType)
                Divider()
                Text("Expense list")
                    .font(.system(.title2, design: .rounded))
                    .foregroundColor(.purple)
                List {
                    ForEach(filteredExpenses) { expense in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(expense.name)")
                                    .font(.title3)
                                Text("\(expense.category)")
                            }
                            Spacer()
                            Text("\(expense.price, specifier: "%.2f") €")
                                .font(.title3)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            // store selected expense into selectedExpense so that it can be edited
                            selectedExpense = expense
                        }
                    }
                }
                .listStyle(.inset)
                .sheet(item: $selectedExpense, onDismiss: {totalMoneySpent = priceCalculator.getTotalSpent()}) { expense in // show edit expense sheet
                    EditExpenseView(dbId: expense.id, filteredExpenses: $filteredExpenses, selectedExpense: expense)
                }
            }
            .toolbar {
                NavigationLink(destination: SearchView(modelCtx: modelCtx)) {
                    Image(systemName: "magnifyingglass")
                }
                Menu {
                    NavigationLink(destination: ExpenseStatsView()) {
                        Text("Expense Stats")
                    }
                    NavigationLink(destination: SettingsView()) {
                        Text("Settings")
                    }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                        //.foregroundColor(.black)
                }
            }
        }
        .background(Color.black)
        .padding()
    }
}

#Preview {
    HomePageView()
}
