//
//  ExpensesTracker_iOSApp.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 22.12.2023..
//

import SwiftUI
import SwiftData

@main
struct ExpensesTracker_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            HomePageView()
        }
        .modelContainer(for: [Expense.self, ScheduledExpense.self])
    }
}
