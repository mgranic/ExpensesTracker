//
//  ExpenseManager.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 30.12.2023..
//

import Foundation


class ExpenseManager: ObservableObject {
    @Published var filteredExpenses: [Expense] = []   // expenses that are show in list to user and from which graph is drawn
    @Published var selectedExpense: Expense?          // expense selected for edditing
    @Published var showFilterAlert: Bool = false      // if true, show alert for bad filtering
    //@Published var totalMoneySpent: Double = 0.0
}
