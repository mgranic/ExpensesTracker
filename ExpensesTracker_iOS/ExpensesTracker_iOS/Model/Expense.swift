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
    case gaming
}
