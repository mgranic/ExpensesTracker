//
//  PriceCalculator.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 09.01.2024..
//

import Foundation

class PriceCalculator {
    
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
        
        
        let lastMonth =  UserDefaults.standard.integer(forKey: "last_month_entered")
        
        var totalMoneySpent: Double = 0.0
        
        // if this is new month then calculate from beginning
        if (lastMonth != currentDateComponents.month) {
            totalMoneySpent = amount
            UserDefaults.standard.setValue(currentDateComponents.month, forKey: "last_month_entered")
        } else { // else do normal calculation
            totalMoneySpent = getTotalSpent() + amount
            
            // if we end up in negative teritory set 0
            if totalMoneySpent < 0.0 {
                totalMoneySpent = 0.0
            }
        }
        
        UserDefaults.standard.setValue(totalMoneySpent, forKey: "total_spent")
    }
    
    // read total spent amount from user defaults
    func getTotalSpent() -> Double{
        let lastMonth =  UserDefaults.standard.integer(forKey: "last_month_entered")
        let currentDateComponents = Calendar.current.dateComponents([.month, .year], from: Date())
        
        // if this is new month then calculate from beginning
        if (lastMonth != currentDateComponents.month) {
            UserDefaults.standard.setValue(currentDateComponents.month, forKey: "last_month_entered")
            UserDefaults.standard.setValue(0.0, forKey: "total_spent")
        }
        
        return UserDefaults.standard.double(forKey: "total_spent")
    }
    
    // calculate total money spent per category
    func totalPricePerCategory(filteredExpenses: [Expense]) -> [(String, Double)] {
        var totalPrice: Dictionary<String, Double> = [:]
    
        // initialize total price dictionary
        for category in Category.allCases {
            totalPrice[category.rawValue] = 0.0
        }
    
        // calculate total price
        for expense in filteredExpenses {
            totalPrice[expense.category] = (totalPrice[expense.category] ?? 0.0) + expense.price
        }
    
        return totalPrice.compactMap({ ($0, $1) })
    }
}
