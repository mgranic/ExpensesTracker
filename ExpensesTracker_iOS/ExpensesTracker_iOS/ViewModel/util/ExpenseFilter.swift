//
//  ExpenseFilter.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 10.01.2024..
//

import Foundation

class ExpenseFilter {
    // Enum that specifies method for calculating date to filter expenses
    enum DateCalculationMethod: Int {
        case day
        case month
        case year
        case max
    }
    
    // reset all filtered data (show all data to user)
    func resetExpensesFilter(filteredExpenses: inout [Expense], expenses: [Expense]) {
        filteredExpenses = expenses.map{$0}
    }
    
    // take list of expenses (expensesToFilter) and filter expense that are newer then the date specified by dateFrom
    // and dateCalcMethod parameters
    func filterExpensesByDate(dateFrom: Int, dateCalcMethod: DateCalculationMethod, expensesToFilter: [Expense], filteredExpenses: inout [Expense], showFilterAlert: inout Bool) {
        var earlyDate: Date?
        
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
            // maximum date is 20 years ago, basically making sure all of your expenses are included
            earlyDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())
        }
        
        do {
            try filteredExpenses = expensesToFilter.filter(Expense.searchByDate(dateFrom: earlyDate!))
        } catch {
            showFilterAlert = true
        }
    }
}
