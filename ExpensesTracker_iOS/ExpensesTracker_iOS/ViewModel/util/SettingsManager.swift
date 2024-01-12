//
//  SettingsManager.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 03.01.2024..
//

import Foundation
import SwiftData

class SettingManager {
    
    // save default chart for homescreen to user defaults
    func setDefaultChart(chartType: ChartType) {
        UserDefaults.standard.setValue(chartType.rawValue, forKey: "default_chart")
    }
    
    // read default_chart from user defaults
    func getDefaultChart() -> ChartType {
        let defaultChart =  ChartType(rawValue: (UserDefaults.standard.string(forKey: "default_chart") ?? "bar")) 
        
        return defaultChart ?? ChartType.bar
    }
    
    // reset all UserDefauls
    func resetUserDefaults(modelContext: ModelContext, showAlert: inout Bool) {
        // used to decide if total price should be calculated for new month
        UserDefaults.standard.removeObject(forKey: "last_month_entered")
        
        // total money spent this month
        UserDefaults.standard.removeObject(forKey: "total_spent")
        
        // chart to be shown on main page
        UserDefaults.standard.removeObject(forKey: "default_chart")
        
        // delete data from database
        do {
            try modelContext.delete(model: Expense.self)
            try modelContext.delete(model: ScheduledExpense.self)
        } catch {
            showAlert = true
        }
    }
}
