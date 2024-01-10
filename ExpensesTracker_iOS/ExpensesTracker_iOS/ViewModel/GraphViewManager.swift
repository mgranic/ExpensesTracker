//
//  GraphViewManager.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 11.01.2024..
//

import Foundation

class GrapshViewManager: ObservableObject {
    @Published var intervalPressed: [Bool] = [false, false, false, false, false, false] // disable filtering twice by same filter
    @Published var totalPricePerCategory: [(String, Double)] = [] // used to render pie chart
    @Published var showFilterAlert: Bool = false      // if true, show alert for bad filtering
    var lastButtonPressed: Int = 0         // record last filter
    
    // set button pressed and reset previous button pressed
    func resetPressedFields(_ buttonPressed: Int) {
        intervalPressed[lastButtonPressed] = false
        intervalPressed[buttonPressed] = true
        lastButtonPressed = buttonPressed
    }
}
