//
//  ContentView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import SwiftUI

struct HomePageView: View {
    var expenseHandler: ExpenseHandler = ExpenseHandler()
    var body: some View {
        VStack {
            HStack {                Button(action:expenseHandler.createExpense) {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .padding()
    }
}

#Preview {
    HomePageView()
}
