//
//  ExpenseHandler.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import Foundation

public class ExpenseHandler: ObservableObject {
    
    @Published var expenses: [Expense] = [] // list of expenses shown to the user
    @Published var selectedExpense: Expense?
    
    // add expense to the list of expenses shown to the user
    func updateListOfExpenses(name: String, price: Double, category: Category) {
        self.expenses.append(Expense(dbId: Int.random(in: 1..<1000), price: price, name: name, category: category, timestamp: Date()))
    }
    
    // create expense and update list of expenses shown to the user
    func createExpense(name: String, price: Double, category: Category, date: Date) {
        Expense.expenses.append(Expense(dbId: Int.random(in: 1..<1000), price: price, name: name, category: category, timestamp: date))
        updateListOfExpenses(name: name, price: price, category: category)
    }
    
    // get all expenses from database
    func getExpenses() {
        expenses = Expense.expenses.map { $0 }
    }
    
    // edit expense with dbId = id with new values provided in function parameters
    func editExpense(id: Int, name: String, price: Double, category: Category, timestamp: Date) {
        for i in 0...(Expense.expenses.count - 1) {
            if (Expense.expenses[i].dbId == id) {
                Expense.expenses[i].name = name
                Expense.expenses[i].price = price
                Expense.expenses[i].category = category
                Expense.expenses[i].timestamp = timestamp
            }
        }
        // TODO: this is just temporary until database is connected. Update array rendered to user
        getExpenses()
    }
    
    // edit expense with dbId = id with new values provided in function parameters
    func deleteExpense(id: Int) {
        for i in 0...(Expense.expenses.count - 1) {
            if (Expense.expenses[i].dbId == id) {
                Expense.expenses.remove(at: i)
                break
            }
        }
        // TODO: this is just temporary until database is connected. Update array rendered to user
        getExpenses()
    }
}
