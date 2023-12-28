//
//  Expense.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import Foundation

struct Expense: Identifiable {
    var id = UUID()
    var dbId: Int
    var price: Double
    var name: String
    var category: Category
    var timestamp: Date
    
    init(id: UUID = UUID(), dbId: Int, price: Double, name: String, category: Category, timestamp: Date) {
        self.id = id
        self.dbId = dbId
        self.price = price
        self.name = name
        self.category = category
        self.timestamp = timestamp
    }
    
    
    
    static var expenses: [Expense] = [
        Expense(dbId: Int.random(in: 1..<1000), price: 500.0, name: "Kredit", category: Category.housing, timestamp: Date()),
        Expense(dbId: Int.random(in: 1..<1000), price: 1.2, name: "Kava", category: Category.caffe, timestamp: Date()),
        Expense(dbId: Int.random(in: 1..<1000), price: 2.3, name: "Kava", category: Category.caffe, timestamp: Date()),
        Expense(dbId: Int.random(in: 1..<1000), price: 1.4, name: "Kava", category: Category.caffe, timestamp: Date()),
        Expense(dbId: Int.random(in: 1..<1000), price: 1.5, name: "Sok", category: Category.caffe, timestamp: Date()),
        Expense(dbId: Int.random(in: 1..<1000), price: 1.6, name: "Sok", category: Category.caffe, timestamp: Date()),
        Expense(dbId: Int.random(in: 1..<1000), price: 50, name: "Meso", category: Category.food, timestamp: Date()),
        Expense(dbId: Int.random(in: 1..<1000), price: 90, name: "Gorivo", category: Category.transportation, timestamp: Date()),
        Expense(dbId: Int.random(in: 1..<1000), price: 200, name: "Registracija", category: Category.transportation, timestamp: Date()),
        
        Expense(dbId: Int.random(in: 1..<1000), price: 500.0, name: "Kredit", category: Category.housing, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -40,
            to: Date())!),
        Expense(dbId: Int.random(in: 1..<1000), price: 1.2, name: "Kava", category: Category.caffe, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -4,
            to: Date())!),
        Expense(dbId: Int.random(in: 1..<1000), price: 2.3, name: "Kava", category: Category.caffe, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -14,
            to: Date())!),
        Expense(dbId: Int.random(in: 1..<1000), price: 100, name: "Kava", category: Category.caffe, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -100,
            to: Date())!),
        Expense(dbId: Int.random(in: 1..<1000), price: 500, name: "Sok", category: Category.caffe, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -400,
            to: Date())!),
        Expense(dbId: Int.random(in: 1..<1000), price: 1.6, name: "Sok", category: Category.caffe, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -500,
            to: Date())!),
        Expense(dbId: Int.random(in: 1..<1000), price: 50, name: "Meso", category: Category.food, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -40,
            to: Date())!),
        Expense(dbId: Int.random(in: 1..<1000), price: 90, name: "Gorivo", category: Category.transportation, timestamp: Calendar.current.date(
            byAdding: .day,
            value: -40,
            to: Date())!),
        Expense(dbId: Int.random(in: 1..<1000), price: 200, name: "Registracija", category: Category.transportation, timestamp: Calendar.current.date(
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
