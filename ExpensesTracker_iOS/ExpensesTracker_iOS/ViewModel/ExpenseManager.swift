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
    @Published var totalMoneySpent: Double = 0.0
    
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
    
    // calculate total money spent per category
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
    
    func setTotalSpentOnEdit(oldAmount: Double, newAmount: Double, oldDate: Date, newDate: Date) {
        let oldDateComponents = Calendar.current.dateComponents([.month, .year], from: oldDate)
        let newDateComponents = Calendar.current.dateComponents([.month, .year], from: newDate)
        let currentDateComponents = Calendar.current.dateComponents([.month, .year], from: Date())
        
        // if old expense is entered for prior month it wasn't used in total amount calculation
        if ((oldDateComponents.month != currentDateComponents.month) ||
            (oldDateComponents.year != currentDateComponents.year)) {
            
            // if new date is set to this month it should be included in total amount calculation
            if ((newDateComponents.month == currentDateComponents.month) &&
                (newDateComponents.year == currentDateComponents.year)) {
                setTotalSpent(amount: newAmount, date: newDate)
            }
            return
        }
        
        // if old expense is entered for this month, but is now changed to some prior month
        if ((newDateComponents.month != currentDateComponents.month) ||
            (newDateComponents.year != currentDateComponents.year)) {
            
            // deduce total amount like expense was deleted
            setTotalSpent(amount: oldAmount * (-1), date: oldDate)
            
            return
        }
        
        // if you reach this part of code it means old date and new date are both for this month and only amount was changed
        // calculate in only difference between new value and old value into total amount
        setTotalSpent(amount: newAmount - oldAmount, date: newDate)
        
    }
    
    // save total spent amount to user defaults
    func setTotalSpent(amount: Double, date: Date) {
        
        let dateComponenets = Calendar.current.dateComponents([.month, .year], from: date)
        let currentDateComponents = Calendar.current.dateComponents([.month, .year], from: Date())
        
        // if expense is entered for prior month don't use it in calculation
        if ((dateComponenets.month != currentDateComponents.month) ||
            (dateComponenets.year != currentDateComponents.year)) {
            return
        }
        
        
        let lastMonth =  UserDefaults.standard.integer(forKey: "last_month_entered") ?? 0
        
        // if this is new month then calculate from beginning
        if (lastMonth != currentDateComponents.month) {
            totalMoneySpent = amount
            UserDefaults.standard.setValue(currentDateComponents.month, forKey: "last_month_entered")
        } else { // else do normal calculation
            getTotalSpent()
            totalMoneySpent = totalMoneySpent + amount
            
            // if we end up in negative teritory set 0
            if totalMoneySpent < 0.0 {
                totalMoneySpent = 0.0
            }
        }
        
        UserDefaults.standard.setValue(totalMoneySpent, forKey: "total_spent")
    }
    
    // read total spent amount from user defaults
    func getTotalSpent() {
        totalMoneySpent =  UserDefaults.standard.double(forKey: "total_spent") ?? 0.0
    }
}
