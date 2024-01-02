//
//  ExpenseManager.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 30.12.2023..
//

import Foundation


class ExpenseManager: ObservableObject {
    @Published var filteredExpenses: [Expense] = []   // expenses that are show in list to user and from which graph is drawn
    @Published var selectedExpense: Expense?          // expense selected for edditing
    @Published var showFilterAlert: Bool = false      // if true, show alert for bad filtering
    
    // Enum that specifies method for calculating date to filter expenses
    enum DateCalculationMethod: Int {
        case day
        case month
        case year
        case max
    }
    
    // reset all filtered data (show all data to user)
    func resetExpensesFilter(expenses: [Expense]) {
        filteredExpenses = expenses.map{$0}
    }
    
    // take list of expenses (expensesToFilter) and filter expense that are newer then the date specified by dateFrom
    // and dateCalcMethod parameters
    func filterExpensesByDate(dateFrom: Int, dateCalcMethod: DateCalculationMethod, expensesToFilter: [Expense]) {
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
    
    func totalPricePerCategory() -> [(String, Double)] {
        var totalPrice: Dictionary<String, Double> = [:]
        
        // initialize total price dictionary
        for category in Category.allCases {
            totalPrice[category.rawValue] = 0.0
        }
        
        // calculate total price
        for expense in filteredExpenses {
            totalPrice[expense.category] = (totalPrice[expense.category] ?? 0.0) + expense.price
        }
        
        return totalPrice.flatMap{ ($0, $1) }
    }
}
