//
//  ContentView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import SwiftUI

struct HomePageView: View {
    @State var isPresentSheet: Bool = false
    @StateObject var expenseHandler: ExpenseHandler = ExpenseHandler()
    
    var body: some View {
        VStack {
            Button(action: {
                isPresentSheet.toggle()
                //expenseHandler.createExpense()
            }) {
                Image(systemName: "plus.circle.fill")
            }
            .sheet(isPresented: $isPresentSheet) {
                AddExpenseView(isPresentSheet: $isPresentSheet, expenseHandler: expenseHandler)
            }
            List {
                ForEach(expenseHandler.expenses, id: \.self) { expense in
                    Text("\(expense.name) - \(expense.price, specifier: "%.2f")")
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
