//
//  ContentView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import SwiftUI
import Charts

struct HomePageView: View {
    @State var showCreateExpenseSheet: Bool = false
    @StateObject var expenseHandler: ExpenseHandler = ExpenseHandler()
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    showCreateExpenseSheet.toggle()
                }) {
                    Text("Add expense")
                    Image(systemName: "plus.circle.fill")
                }
                .sheet(isPresented: $showCreateExpenseSheet) {
                    AddExpenseView(isPresentSheet:$showCreateExpenseSheet, expenseHandler: expenseHandler)
                }
                Chart {
                    ForEach(expenseHandler.expenses) { expense in
                        BarMark(
                            x: .value("Article", expense.category.rawValue),
                            y: .value("Price", expense.price)
                        )
                    }
                }
                HStack {
                    Button {
                        expenseHandler.getExpensesFromDate(dateFrom: 1, dateCalcMethod: .day)
                    } label: {
                        Text("1D")
                    }
                    Spacer()
                    Button {
                        expenseHandler.getExpensesFromDate(dateFrom: 7, dateCalcMethod: .day)
                    } label: {
                        Text("1W")
                    }
                    Spacer()
                    Button {
                        expenseHandler.getExpensesFromDate(dateFrom: 1, dateCalcMethod: .month)
                    } label: {
                        Text("1M")
                    }
                    Spacer()
                    Button {
                        expenseHandler.getExpensesFromDate(dateFrom: 3, dateCalcMethod: .month)
                    } label: {
                        Text("3M")
                    }
                    Spacer()
                    Button {
                        expenseHandler.getExpensesFromDate(dateFrom: 1, dateCalcMethod: .year)
                    } label: {
                        Text("1Y")
                    }
                    Spacer()
                    Button {
                        expenseHandler.getExpensesFromDate(dateFrom: 0, dateCalcMethod: .max)
                    } label: {
                        Text("MAX")
                    }
                }
                List {
                    ForEach(expenseHandler.expenses) { expense in
                        Text("\(expense.name) - \(expense.price, specifier: "%.2f")")
                            .onTapGesture {
                                expenseHandler.selectedExpense = expense
                            }
                    }
                }
                .sheet(item: $expenseHandler.selectedExpense) { expense in
                    EditExpenseView(name: expense.name, price: expense.price, category: expense.category, date: expense.timestamp, expenseHandler: expenseHandler)
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
        .onAppear(perform: {
            expenseHandler.getExpenses()
        })
        .padding()
    }
}

#Preview {
    HomePageView()
}
