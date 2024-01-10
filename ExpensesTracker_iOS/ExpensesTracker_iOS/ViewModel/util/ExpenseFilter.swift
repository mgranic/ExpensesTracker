//
//  ExpenseFilter.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 10.01.2024..
//

import Foundation
import SwiftData

class ExpenseFilter {
    
    // Enum that specifies method for calculating date to filter expenses
    enum DateCalculationMethod: Int {
        case day
        case month
        case year
        case max
    }
    
    // filter expense that are newer then the date specified by dateFrom and dateCalcMethod parameters
    func getExpensesByDate(dateFrom: Int, dateCalcMethod: DateCalculationMethod, showFilterAlert: inout Bool, modelContext: ModelContext) -> [Expense] {
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
            let predicate = Expense.searchByDate(dateFrom: earlyDate!)
            let descriptor = FetchDescriptor<Expense>(predicate: predicate)
            return try modelContext.fetch(descriptor)
        } catch {
            showFilterAlert = true
        }
        return []
    }
    
    // filter expenses by all possible parameters
    func getFilteredExpenseList(modelContext: ModelContext, name: String, category: String, priceFrom: Double, priceTo: Double, dateFrom: Date, dateTo: Date) -> [Expense] {
        let predicate = Expense.searchExpense(dateFrom: dateFrom, dateTo: dateTo, priceFome: priceFrom, priceTo: priceTo, name: name, category: category)
        let descriptor = FetchDescriptor<Expense>(predicate: predicate)
        return try! modelContext.fetch(descriptor)
    }
    
    // get all expenses
    func getAllExpenses(modelContext: ModelContext) -> [Expense] {
        let descriptor = FetchDescriptor<Expense>(sortBy: [SortDescriptor(\.timestamp)])
        return try! modelContext.fetch(descriptor)
    }
}
