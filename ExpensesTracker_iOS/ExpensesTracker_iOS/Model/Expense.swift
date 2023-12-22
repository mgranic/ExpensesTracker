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
    
    static var expenses: [Expense] = [Expense(price: 1.2, name: "Kava")]
}
