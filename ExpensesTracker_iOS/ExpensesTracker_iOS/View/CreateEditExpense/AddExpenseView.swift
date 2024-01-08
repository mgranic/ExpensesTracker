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
    @ObservedObject var expenseManager: ExpenseManager

    var body: some View {
        VStack {
            CreateEditExpenseFormView(isPresent: $isPresentSheet, expenseManager: _expenseManager)
        }
        .background(Color.black)
    }
}
