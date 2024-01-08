//
//  Expense.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import Foundation
import SwiftData


@Model
class Expense {
    var id = UUID()
    var price: Double
    var name: String
    var category: String
    var timestamp: Date
    
    init(id: UUID = UUID(), price: Double, name: String, category: String, timestamp: Date) {
        self.id = id
        self.price = price
        self.name = name
        self.category = category
        self.timestamp = timestamp
    }
 
    
    // return predicate to filter all expenses from database that are created after the specified date (dateFrom)
    static func searchByDate(
        dateFrom: Date
    ) -> Predicate<Expense> {

        return #Predicate<Expense> { expense in
            expense.timestamp > dateFrom
        }
    }
    
    static func searchExpense(
        dateFrom: Date,
        dateTo: Date,
        priceFome: Double,
        priceTo: Double,
        name: String,
        category: String
    ) -> Predicate<Expense> {
        
        if (name != "" && category != Category.none.rawValue) {
            return #Predicate<Expense> { expense in
                (expense.timestamp > dateFrom) &&
                (expense.timestamp <= dateTo) &&
                (expense.price > priceFome) &&
                (expense.price <= priceTo) &&
                (expense.name.contains(name)) &&
                (expense.category == category)
            }
        } else if (name != "" && category == Category.none.rawValue) {
            return #Predicate<Expense> { expense in
                (expense.timestamp > dateFrom) &&
                (expense.timestamp <= dateTo) &&
                (expense.price > priceFome) &&
                (expense.price <= priceTo) &&
                (expense.name.contains(name))
            }
        } else if (name == "" && category != Category.none.rawValue) {
            return #Predicate<Expense> { expense in
                (expense.timestamp > dateFrom) &&
                (expense.timestamp <= dateTo) &&
                (expense.price > priceFome) &&
                (expense.price <= priceTo) &&
                (expense.category == category)
            }
        } else {
            return #Predicate<Expense> { expense in
                (expense.timestamp > dateFrom) &&
                (expense.timestamp <= dateTo) &&
                (expense.price > priceFome) &&
                (expense.price < priceTo)
            }
        }

        
    }
}

enum Category: String, CaseIterable {
    case none
    case caffe
    case food
    case transportation
    case clothing
    case housing
    case bills
    case travel
    case electronics
    case subscriptions
    case kids
    case hobby
    case sports
    case fun
    case other
}
