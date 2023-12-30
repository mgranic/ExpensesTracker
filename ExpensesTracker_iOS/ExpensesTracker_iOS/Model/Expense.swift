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
    
    static func searchByDate(
        dateFrom: Int,
        dateCalcMethod: DateCalculationMethod
    ) -> Predicate<Expense> {
        
        var earlyDate: Date? = nil
        
        
        switch dateCalcMethod {
            case .day:
                earlyDate = Calendar.current.date(byAdding: .day, value: -dateFrom, to: Date())
            case .month:
                earlyDate = Calendar.current.date(byAdding: .month, value: -dateFrom, to: Date())
            case .year:
                earlyDate = Calendar.current.date(byAdding: .year, value: -dateFrom, to: Date())
        case .max:
            fallthrough
            default:
            // maximum date is 20 zears ago, basically making sure all of your expenses are included
            earlyDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())
        }

        return #Predicate<Expense> { expense in
            expense.timestamp > earlyDate!
        }
    }
}

// Method for calculating date to filter expenses
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
    case gaming
}
