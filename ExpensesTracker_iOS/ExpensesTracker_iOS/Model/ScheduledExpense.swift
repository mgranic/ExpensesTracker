//
//  ScheduledExpense.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 12.01.2024..
//

import Foundation
import SwiftData

@Model
class ScheduledExpense {
    var id: UUID
    var name: String
    var price: Double
    var category: String
    var startDate: Date
    var interval: String
    var isActive: Bool
    var lastExecuted: Date
    var isFirstExecution: Bool
    
    init(id: UUID = UUID(), name: String, price: Double, category: String, startDate: Date = Date(), interval: String = ExpenseInterval.month.rawValue, isActive: Bool = true) {
        self.id = id
        self.name = name
        self.price = price
        self.category = category
        self.startDate = startDate
        self.interval = interval
        self.isActive = true
        self.lastExecuted = startDate
        self.isFirstExecution = true
    }
}
