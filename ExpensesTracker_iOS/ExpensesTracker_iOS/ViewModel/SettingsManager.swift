//
//  SettingsManager.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 03.01.2024..
//

import Foundation

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
}
