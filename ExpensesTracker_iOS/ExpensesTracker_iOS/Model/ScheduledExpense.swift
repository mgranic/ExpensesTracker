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
    var intervalStep: Int
    var isRecurring: Bool
    var isActive: Bool
    
    init(id: UUID = UUID(), name: String, price: Double, category: String, startDate: Date = Date(), interval: String = ExpenseInterval.month.rawValue, intervalStep: Int, isRecurring: Bool = false, isActive: Bool = true) {
        self.id = id
        self.name = name
        self.price = price
        self.category = category
        self.startDate = startDate
        self.interval = interval
        self.intervalStep = intervalStep
        self.isRecurring = isRecurring
        self.isActive = true
    }
}

enum ExpenseInterval: String, CaseIterable {
    case day
    case week
    case month
    case year
}
