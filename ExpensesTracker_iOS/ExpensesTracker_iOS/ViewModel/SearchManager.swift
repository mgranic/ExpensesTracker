//
//  SearchManager.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 09.01.2024..
//

import Foundation
import SwiftData

extension SearchView {
    class SearchManager : ObservableObject {
        var modelContext: ModelContext
        @Published var expenseList: [Expense] = []
        let expenseFilter = ExpenseFilter()
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            //getAllExpenses()
        }
        
        func getFilteredExpenseList(name: String, category: String, priceFrom: Double, priceTo: Double, dateFrom: Date, dateTo: Date) {
            expenseList = expenseFilter.getFilteredExpenseList(modelContext: modelContext, name: name, category: category, priceFrom: priceFrom, priceTo: priceTo, dateFrom: dateFrom, dateTo: dateTo)
        }
        
        func getAllExpenses() {
            expenseList = expenseFilter.getAllExpenses(modelContext: modelContext)
        }
    }
}
