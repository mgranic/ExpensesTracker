//
//  ContentView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import SwiftUI

struct HomePageView: View {
    @StateObject var expenseHandler: ExpenseHandler = ExpenseHandler()
    var body: some View {
        VStack {
            HStack {                Button(action:expenseHandler.createExpense) {
                    Image(systemName: "plus.circle.fill")
                }
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
