//
//  Expense.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import Foundation

struct Expense: Identifiable {
    var id: Int
    var price: Double
    var name: String
    var category: Category
    
    
    
    static var expenses: [Expense] = [
        Expense(id: Int.random(in: 1..<1000), price: 1.2, name: "Kava", category: Category.caffe),
        Expense(id: Int.random(in: 1..<1000), price: 2.3, name: "Kava", category: Category.caffe),
        Expense(id: Int.random(in: 1..<1000), price: 1.4, name: "Kava", category: Category.caffe),
        Expense(id: Int.random(in: 1..<1000), price: 1.5, name: "Sok", category: Category.caffe),
        Expense(id: Int.random(in: 1..<1000), price: 1.6, name: "Sok", category: Category.caffe)]
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
