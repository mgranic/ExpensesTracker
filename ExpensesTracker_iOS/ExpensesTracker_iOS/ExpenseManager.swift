//
//  ExpenseManager.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 30.12.2023..
//

import Foundation


class ExpenseManager: ObservableObject {
    //private var allExpenses: [Expense] = []
    @Published var filteredExpenses: [Expense] = []
    @Published var selectedExpense: Expense?
    
    // Method for calculating date to filter expenses
    enum DateCalculationMethod: Int {
        case day
        case month
        case year
        case max
    }
    
    //func updateExpenses(expenses: [Expense]) {
    //    allExpenses = expenses.map{$0}
    //    resetExpensesFilter()
    //}
    
    func resetExpensesFilter(expenses: [Expense]) {
        filteredExpenses = expenses.map{$0}
    }
    
    func filterExpensesByDate(dateFrom: Int, dateCalcMethod: DateCalculationMethod, expensesToFilter: [Expense]) {
        var earlyDate: Date? = nil
        
        switch dateCalcMethod {
            case .day:
                earlyDate = Calendar.current.date(byAdding: .day, value: -dateFrom, to: Date())
            case .month:
                earlyDate = Calendar.current.date(byAdding: .month, value: -dateFrom, to: Date())
            case .year:
                earlyDate = Calendar.current.date(byAdding: .year, value: -dateFrom, to: Date())
        case .max:
            fallthrough
            default:
            // maximum date is 20 zears ago, basically making sure all of your expenses are included
            earlyDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())
        }
        
        do {
            try filteredExpenses = expensesToFilter.filter(Expense.searchByDate(dateFrom: earlyDate!))
        } catch {
            print("Unexpected error: \(error).")
        }
    }
}
