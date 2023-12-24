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
    func updateListOfExpenses(name: String, price: Double, category: Category) {
        self.expenses.append(Expense(id: Int.random(in: 1..<1000), price: price, name: name, category: category))
    }
    
    // create expense and update list of expenses shown to the user
    func createExpense(name: String, price: Double, category: Category) {
        Expense.expenses.append(Expense(id: Int.random(in: 1..<1000), price: price, name: name, category: category))
        updateListOfExpenses(name: name, price: price, category: category)
    }
    
    // get all expenses from database
    func getExpenses() {
        expenses = Expense.expenses.map { $0 }
    }
}
