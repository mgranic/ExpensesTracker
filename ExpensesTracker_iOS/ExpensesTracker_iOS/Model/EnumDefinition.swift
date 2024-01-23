//
//  EnumDefinition.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 23.01.2024..
//

import Foundation


// Enum that specifies method for calculating date to filter expenses
enum DateCalculationMethod: Int {
    case day
    case month
    case year
    case max
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
    case health
    case supplements
    case gifts
    case other
}

enum ChartType: String, CaseIterable {
    case bar
    case pie
}

enum ExpenseInterval: String, CaseIterable {
    case day
    case week
    case month
    case year
}
