//
//  ExpenseHandler.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import Foundation

public class ExpenseHandler: ObservableObject {
    
    @Published var expenses: [Expense] = [] // list of expenses shown to the user
    
    // add expense to the list of expenses shown to the user
    func updateListOfExpenses(name: String, price: Double) {
        self.expenses.append(Expense(price: price, name: name))
    }
    
    // create expense and update list of expenses shown to the user
    func createExpense(name: String, price: Double) {
        Expense.expenses.append(Expense(price: price, name: name))
        updateListOfExpenses(name: name, price: price)
    }
    
    // get all expenses from database
    func getExpenses() {
        expenses = Expense.expenses.map { $0 }
    }
}
