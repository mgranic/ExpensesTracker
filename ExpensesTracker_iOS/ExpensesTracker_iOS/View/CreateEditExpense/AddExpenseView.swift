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

    var body: some View {
        VStack {
            CreateEditExpenseFormView(isPresent: $isPresentSheet, selectedExpense: Expense(price: 0.0, name: "", category: Category.none.rawValue, timestamp: Date()), filteredExpenses: $filteredExpenses)
        }
    }
}
