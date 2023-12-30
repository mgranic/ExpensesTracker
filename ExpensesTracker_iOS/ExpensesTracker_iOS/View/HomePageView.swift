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
    @StateObject var expenseHandler: ExpenseHandler = ExpenseHandler()
    @State var date: Date? = nil
    
    
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
                    AddExpenseView(isPresentSheet:$showCreateExpenseSheet, selectedExpense: Expense(price: 0.0, name: "", category: Category.none.rawValue, timestamp: Date()))
                }
                Chart {
                    ForEach(expenses) { expense in
                        // if date is not nil filter by date
                        if let tempDate = date {
                            if (expense.timestamp > tempDate) {
                                BarMark(
                                    x: .value("Article", expense.category),
                                    y: .value("Price", expense.price)
                                )
                            }
                        } else {
                            // if date is nill render all expenses
                            BarMark(
                                x: .value("Article", expense.category),
                                y: .value("Price", expense.price)
                            )
                        }
                        
                    }
                }
                HStack {
                    Button {
                        date = expenseHandler.getExpensesFromDate(dateFrom: 1, dateCalcMethod: .day)
                    } label: {
                        Text("1D")
                    }
                    Spacer()
                    Button {
                        date = expenseHandler.getExpensesFromDate(dateFrom: 7, dateCalcMethod: .day)
                    } label: {
                        Text("1W")
                    }
                    Spacer()
                    Button {
                        date = expenseHandler.getExpensesFromDate(dateFrom: 1, dateCalcMethod: .month)
                    } label: {
                        Text("1M")
                    }
                    Spacer()
                    Button {
                        date = expenseHandler.getExpensesFromDate(dateFrom: 3, dateCalcMethod: .month)
                    } label: {
                        Text("3M")
                    }
                    Spacer()
                    Button {
                        date = expenseHandler.getExpensesFromDate(dateFrom: 1, dateCalcMethod: .year)
                    } label: {
                        Text("1Y")
                    }
                    Spacer()
                    Button {
                        date = expenseHandler.getExpensesFromDate(dateFrom: 0, dateCalcMethod: .max)
                    } label: {
                        Text("MAX")
                    }
                }
                List {
                    ForEach(expenses) { expense in
                        Text("\(expense.name) - \(expense.price, specifier: "%.2f")")
                            .onTapGesture {
                                expenseHandler.selectedExpense = expense
                            }
                    }
                }
                .sheet(item: $expenseHandler.selectedExpense) { expense in
                    EditExpenseView(selectedExpense: expense, dbId: expense.id)
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
