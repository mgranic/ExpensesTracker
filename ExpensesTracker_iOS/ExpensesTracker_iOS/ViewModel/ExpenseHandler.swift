//
//  ExpenseHandler.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import Foundation

public class ExpenseHandler {
    func createExpense() {
        Expense.expenses.append(Expense(price: 2.0, name: "Kava 2"))
        for expense in Expense.expenses {
            print("Price : \(expense)")
        }
    }
}
