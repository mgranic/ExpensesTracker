//
//  ExpenseHandler.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import Foundation

public class ExpenseHandler: ObservableObject {
    
    @Published var expenses: [Expense] = []  // list of expenses shown to the user
    @Published var selectedExpense: Expense? // used to pass expense that will be eddited to EditView
    
    // Method for calculating date to filter expenses
    enum DateCalculationMethod: Int {
        case day
        case month
        case year
        case max
    }
    
    // add expense to the list of expenses shown to the user
    func updateListOfExpenses(name: String, price: Double, category: Category) {
        self.expenses.append(Expense(price: price, name: name, category: category, timestamp: Date()))
    }
    
    // create expense and update list of expenses shown to the user
    func createExpense(name: String, price: Double, category: Category, date: Date) {
        Expense.expenses.append(Expense(price: price, name: name, category: category, timestamp: date))
        updateListOfExpenses(name: name, price: price, category: category)
    }
    
    // get all expenses from database
    func getExpenses() {
        expenses = Expense.expenses.map { $0 }
    }
    
    // edit expense with dbId = id with new values provided in function parameters
    func editExpense(id: UUID, name: String, price: Double, category: Category, timestamp: Date) {
        for i in 0...(Expense.expenses.count - 1) {
            if (Expense.expenses[i].id == id) {
                Expense.expenses[i].name = name
                Expense.expenses[i].price = price
                Expense.expenses[i].category = category
                Expense.expenses[i].timestamp = timestamp
            }
        }
        // Update array rendered to user
        getExpenses()
    }
    
    // edit expense with dbId = id with new values provided in function parameters
    func deleteExpense(id: UUID) {
        for i in 0...(Expense.expenses.count - 1) {
            if (Expense.expenses[i].id == id) {
                Expense.expenses.remove(at: i)
                break
            }
        }
        // Update array rendered to user
        getExpenses()
    }
    
    // get all expenses from the date specified in fromDate parameter
    func getExpensesFromDate(dateFrom: Int, dateCalcMethod: DateCalculationMethod) {
        // Reset array rendered to user
        getExpenses()
        
        // if max show all expenses, filter nothing
        if (dateCalcMethod == DateCalculationMethod.max) {
            return
        }
        var earlyDate: Date?
        var removeIndexes: [Int] = []
        
        switch dateCalcMethod {
            case .day:
                earlyDate = Calendar.current.date(byAdding: .day, value: -dateFrom, to: Date())
            case .month:
                earlyDate = Calendar.current.date(byAdding: .month, value: -dateFrom, to: Date())
            case .year:
                fallthrough
            default:
                earlyDate = Calendar.current.date(byAdding: .year, value: -dateFrom, to: Date())
        }
        
        // store indexes of all expenses that do not pass the date filter, these Expenses will be not be shown to user
        for i in 0...(expenses.count - 1) {
            if (expenses[i].timestamp < earlyDate!) {
                removeIndexes.append(i)
            }
        }
        
        // remove expenses that are not shown to user
        expenses = expenses
            .enumerated()
            .filter { !removeIndexes.contains($0.offset) }
            .map { $0.element }
    }
}
