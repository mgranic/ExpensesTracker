//
//  GraphConfig.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 01.01.2024..
//

import Foundation

struct GraphConfig {
    var xAxis: AxisValue
    var yAxis: AxisValue
    var type: ChartType
}

enum ChartType: String, CaseIterable {
    case bar
    case line
    case point
    case ruler
    case rectangle
    case area
}

enum AxisValue: String, CaseIterable {
    case category
    case price
    case retailer
    case date
    case name
}
