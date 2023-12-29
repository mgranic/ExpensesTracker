//
//  Expense.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import Foundation
import SwiftData


@Model
class Expense: Identifiable {
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
    
    
    
    static var expenses: [Expense] = [
        Expense(price: 500.0, name: "Kredit", category: Category.housing.rawValue, timestamp: Date()),
        Expense(price: 1.2, name: "Kava", category: Category.caffe.rawValue, timestamp: Date()),
        Expense(price: 2.3, name: "Kava", category: Category.caffe.rawValue, timestamp: Date()),
        Expense(price: 1.4, name: "Kava", category: Category.caffe.rawValue, timestamp: Date()),
        Expense(price: 1.5, name: "Sok", category: Category.caffe.rawValue, timestamp: Date()),
        Expense(price: 1.6, name: "Sok", category: Category.caffe.rawValue, timestamp: Date()),
        Expense(price: 50, name: "Meso", category: Category.food.rawValue, timestamp: Date()),
        Expense(price: 90, name: "Gorivo", category: Category.transportation.rawValue, timestamp: Date()),
        Expense(price: 200, name: "Registracija", category: Category.transportation.rawValue, timestamp: Date()),
        
        Expense(price: 500.0, name: "Kredit", category: Category.housing.rawValue, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -40,
            to: Date())!),
        Expense(price: 1.2, name: "Kava", category: Category.caffe.rawValue, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -4,
            to: Date())!),
        Expense(price: 2.3, name: "Kava", category: Category.caffe.rawValue, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -14,
            to: Date())!),
        Expense(price: 100, name: "Kava", category: Category.caffe.rawValue, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -100,
            to: Date())!),
        Expense(price: 500, name: "Sok", category: Category.caffe.rawValue, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -400,
            to: Date())!),
        Expense(price: 1.6, name: "Sok", category: Category.caffe.rawValue, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -500,
            to: Date())!),
        Expense(price: 50, name: "Meso", category: Category.food.rawValue, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -40,
            to: Date())!),
        Expense(price: 90, name: "Gorivo", category: Category.transportation.rawValue, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -40,
            to: Date())!),
        Expense(price: 200, name: "Registracija", category: Category.transportation.rawValue, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -4,
            to: Date())!)
    ]
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
