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
    @Binding var filteredExpenses: [Expense]

    var body: some View {
        VStack {
            CreateEditExpenseFormView(selectedExpense: selectedExpense, filteredExpenses: $filteredExpenses)
            Button {
                try! modelCtx.delete(model: Expense.self, where: #Predicate { expense in expense.id == dbId })
                filteredExpenses.removeAll(where: { expense in expense.id == dbId})
                dismiss()
            } label: {
                Text("DELETE EXPENSE")
                    .foregroundColor(.red)
            }
        }
    }
}
