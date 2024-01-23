//
//  PriceCalculator.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 09.01.2024..
//

import Foundation
import SwiftData

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
    
    //calculate total money spent speciffic category within specific time interval
    func totalPricePerCategoryInInterval(modelCtx: ModelContext, category: String, dateFrom: Int = 1, interval: ExpenseInterval) -> Double {
        var totalPrice = 0.0
        let expenseFilter = ExpenseFilter()
        let calculatedIntervalMethod = intervalToCalcMethod(interval, dateFrom)
        
        // get list of expenses
        let expenseList = expenseFilter.getExpensesByDateAndCategory(modelContext: modelCtx, category: category, dateFrom: calculatedIntervalMethod.1, dateCalcMethod: calculatedIntervalMethod.0)
        
        // calculate total price
        for expense in expenseList {
            totalPrice = totalPrice + expense.price
        }
        
        return totalPrice
    }
    
    //calculate total money spent speciffic category per specific time interval (daily, weekly ...)
    func totalPricePerCategoryPerInterval(modelCtx: ModelContext, category: String, dateFrom: Int = 1, interval: ExpenseInterval) -> Double {
        var totalPrice = 0.0
        let expenseFilter = ExpenseFilter()
        
        // get list of expenses
        let expenseList = expenseFilter.getExpensesByCategory(modelContext: modelCtx, category: category)
        
        let numberOfDaysPast = numberOfDaysBetween(expenseList[0].timestamp, and: expenseList[expenseList.count - 1].timestamp)
        
        // calculate total price
        for expense in expenseList {
            totalPrice = totalPrice + expense.price
        }
        
        return (totalPrice / calcMethodNumberOfIntervals(interval, numberOfDaysPast: numberOfDaysPast))
    }
    
    /*****************************************************PRIVATE FUNCTIONS**********************************************************/
    
    // transform ExpenseInterval into DateCalculationMethod
    private func intervalToCalcMethod(_ interval: ExpenseInterval, _ dateFrom: Int) -> (DateCalculationMethod, Int) {
        //var dateCalcMethod = DateCalculationMethod.month
        var dateCalcMethod = (DateCalculationMethod.month, dateFrom)
        
        
        // do the transformation
        
        switch interval {
        case .day:
            dateCalcMethod = (DateCalculationMethod.day, dateFrom)
        case .week:
            dateCalcMethod = (DateCalculationMethod.day, (dateFrom * 7))
        case .month:
            dateCalcMethod = (DateCalculationMethod.month, dateFrom)
        case .year:
            dateCalcMethod = (DateCalculationMethod.year, dateFrom)
        default:
            // maximum date is 20 years ago, basically making sure all of your expenses are included
            dateCalcMethod = (DateCalculationMethod.year, 20)
        }
        
        return dateCalcMethod
    }
    
    // calculate number of intervals between latest and oldest expense. Total price will be divided by this number to calculate average in an interval
    private func calcMethodNumberOfIntervals(_ interval: ExpenseInterval, numberOfDaysPast: Int) -> Double {
        var numOfIntervals = Double(numberOfDaysPast)
        
        
        // do the transformation
        
        switch interval {
        case .day:
            numOfIntervals = Double(numberOfDaysPast)
        case .week:
            numOfIntervals = Double(numberOfDaysPast) / 7
        case .month:
            numOfIntervals = Double(numberOfDaysPast) / 30
        case .year:
            numOfIntervals = Double(numberOfDaysPast) / 365
        default:
            numOfIntervals = Double(numberOfDaysPast)
        }
        
        return numOfIntervals
    }
    
    // number of days between two dates
    private func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = Calendar.current.startOfDay(for: from) // <1>
        let toDate = Calendar.current.startOfDay(for: to) // <2>
        let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}
