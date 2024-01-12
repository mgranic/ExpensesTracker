//
//  ScheduleExpenseManager.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 13.01.2024..
//

import Foundation
import SwiftData

class ScheduleExpenseManager {
    
    var modelCtx: ModelContext
    
    init(modelCtx: ModelContext) {
        self.modelCtx = modelCtx
    }
    
    func getAllScheduledExpenses() -> [ScheduledExpense] {
        let descriptor = FetchDescriptor<ScheduledExpense>(sortBy: [SortDescriptor(\.name)])
        return try! modelCtx.fetch(descriptor)
    }
    
    func createScheduledExpense(scheduledExpense: ScheduledExpense) {
        modelCtx.insert(scheduledExpense)
    }
}
