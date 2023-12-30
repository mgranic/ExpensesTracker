//
//  ExpenseHandler.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import Foundation

public class ExpenseHandler: ObservableObject {
    
    @Published var selectedExpense: Expense? // used to pass expense that will be eddited to EditView
    
    // Method for calculating date to filter expenses
    enum DateCalculationMethod: Int {
        case day
        case month
        case year
        case max
    }
    
    // get all expenses from the date specified in fromDate parameter
    func getExpensesFromDate(dateFrom: Int, dateCalcMethod: DateCalculationMethod) -> Date? {
        //// Reset array rendered to user
        //getExpenses()
        
        var earlyDate: Date? = nil
        
        // if max show all expenses, filter nothing
        if (dateCalcMethod == DateCalculationMethod.max) {
            return earlyDate
        }
        
        //var removeIndexes: [Int] = []
        
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
        
        return earlyDate
    }
}
