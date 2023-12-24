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
                    AddExpenseView(isPresentSheet:$showCreateExpenseSheet, expenseHandler:expenseHandler)
                }
                Chart {
                    ForEach(expenseHandler.expenses) { expense in
                        BarMark(
                            x: .value("Article", expense.name),
                            y: .value("Price", expense.price)
                        )
                    }
                }
                List {
                    ForEach(expenseHandler.expenses) { expense in
                        Text("\(expense.name) - \(expense.price, specifier: "%.2f")")
                    }
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
