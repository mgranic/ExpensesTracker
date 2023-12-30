//
//  EditExpenseView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 25.12.2023..
//

import SwiftUI

struct EditExpenseView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelCtx

    var selectedExpense: Expense
    var dbId: UUID

    var body: some View {
        VStack {
            CreateEditExpenseFormView(selectedExpense: selectedExpense)
            Button {
                //if let dbId = expenseHandler.selectedExpense?.id {
                //    try! modelCtx.delete(model: Expense.self, where: #Predicate { expense in expense.id == dbId })
                //}
                try! modelCtx.delete(model: Expense.self, where: #Predicate { expense in expense.id == dbId })
                dismiss()
            } label: {
                Text("DELETE EXPENSE")
                    .foregroundColor(.red)
            }
        }
    }
}
