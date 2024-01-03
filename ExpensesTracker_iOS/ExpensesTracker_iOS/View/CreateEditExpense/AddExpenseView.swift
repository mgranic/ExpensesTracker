//
//  AddExpenseView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 23.12.2023..
//

import Foundation
import SwiftUI

struct AddExpenseView: View {
    
    @Binding var isPresentSheet: Bool
    @Binding var filteredExpenses: [Expense]
    @ObservedObject var expenseManager: ExpenseManager

    var body: some View {
        VStack {
            CreateEditExpenseFormView(isPresent: $isPresentSheet, filteredExpenses: $filteredExpenses, expenseManager: _expenseManager)
        }
    }
}
