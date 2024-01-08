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
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            //getAllExpenses()
        }
        
        func getFilteredExpenseList(name: String, category: String, priceFrom: Double, priceTo: Double, dateFrom: Date, dateTo: Date) {
            let predicate = Expense.searchExpense(dateFrom: dateFrom, dateTo: dateTo, priceFome: priceFrom, priceTo: priceTo, name: name, category: category)
            let descriptor = FetchDescriptor<Expense>(predicate: predicate)
            expenseList = try! self.modelContext.fetch(descriptor)
        }
        
        func getAllExpenses() {
            let descriptor = FetchDescriptor<Expense>(sortBy: [SortDescriptor(\.timestamp)])
            expenseList = try! self.modelContext.fetch(descriptor)
            
            //for expense in expenseList {
            //    print(expense.name)
            //}
        }
    }
}
