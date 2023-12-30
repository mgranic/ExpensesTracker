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
    @State var selectedExpense: Expense?
    @State var filteredExpenses: [Expense] = []
    
    
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
                    try! filteredExpenses = expenses.filter(Expense.searchByDate(dateFrom: 0, dateCalcMethod: .max))
                })
                .sheet(isPresented: $showCreateExpenseSheet) {
                    AddExpenseView(isPresentSheet:$showCreateExpenseSheet, filteredExpenses: $filteredExpenses, selectedExpense: Expense(price: 0.0, name: "", category: Category.none.rawValue, timestamp: Date()))
                }
                Chart {
                    ForEach(filteredExpenses) { expense in
                        BarMark(
                            x: .value("Article", expense.category),
                            y: .value("Price", expense.price)
                        )
                    }
                }
                HStack {
                    Button {
                        try! filteredExpenses = expenses.filter(Expense.searchByDate(dateFrom: 1, dateCalcMethod: .day))
                    } label: {
                        Text("1D")
                    }
                    Spacer()
                    Button {
                        try! filteredExpenses = expenses.filter(Expense.searchByDate(dateFrom: 7, dateCalcMethod: .day))
                    } label: {
                        Text("1W")
                    }
                    Spacer()
                    Button {
                        try! filteredExpenses = expenses.filter(Expense.searchByDate(dateFrom: 1, dateCalcMethod: .month))
                    } label: {
                        Text("1M")
                    }
                    Spacer()
                    Button {
                        try! filteredExpenses = expenses.filter(Expense.searchByDate(dateFrom: 3, dateCalcMethod: .month))
                    } label: {
                        Text("3M")
                    }
                    Spacer()
                    Button {
                        try! filteredExpenses = expenses.filter(Expense.searchByDate(dateFrom: 1, dateCalcMethod: .year))
                    } label: {
                        Text("1Y")
                    }
                    Spacer()
                    Button {
                        try! filteredExpenses = expenses.filter(Expense.searchByDate(dateFrom: 0, dateCalcMethod: .max))
                    } label: {
                        Text("MAX")
                    }
                }
                List {
                    ForEach(filteredExpenses) { expense in
                        Text("\(expense.name) - \(expense.price, specifier: "%.2f")")
                            .onTapGesture {
                                selectedExpense = expense
                            }
                    }
                }
                .sheet(item: $selectedExpense) { expense in
                    EditExpenseView(selectedExpense: expense, dbId: expense.id, filteredExpenses: $filteredExpenses)
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
