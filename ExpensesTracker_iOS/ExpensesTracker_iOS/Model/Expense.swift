//
//  Expense.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import Foundation

struct Expense: Hashable {
    var price: Double
    var name: String
    
    static var expenses: [Expense] = [
        Expense(price: 1.2, name: "Kava"),
        Expense(price: 2.3, name: "Kava"),
        Expense(price: 1.4, name: "Kava"),
        Expense(price: 1.5, name: "Sok"),
        Expense(price: 1.6, name: "Sok")]
}
