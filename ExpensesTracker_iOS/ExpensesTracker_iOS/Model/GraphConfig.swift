//
//  GraphConfig.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 01.01.2024..
//

import Foundation

struct GraphConfig {
    var type: ChartType
}

enum ChartType: String, CaseIterable {
    case bar
    case pie
}
