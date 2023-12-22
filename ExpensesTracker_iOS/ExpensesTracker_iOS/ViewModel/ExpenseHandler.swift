//
//  ExpenseHandler.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import Foundation

public class ExpenseHandler: ObservableObject {
    
    @Published var expenses: [Expense] = []
    
    func createExpense() {
        Expense.expenses.append(Expense(price: 2.0, name: "Kava 2"))
        for expense in Expense.expenses {
            print("Price : \(expense)")
        }
        getExpenses()
    }
    
    func getExpenses() {
        expenses = Expense.expenses.map { $0 }
    }
}
