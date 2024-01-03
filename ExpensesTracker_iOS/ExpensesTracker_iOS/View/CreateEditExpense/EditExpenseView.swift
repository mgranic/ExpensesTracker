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
    @State var showAlert: Bool = false
    @ObservedObject var expenseManager: ExpenseManager
    
    var body: some View {
        VStack {
            CreateEditExpenseFormView(selectedExpense: selectedExpense, filteredExpenses: $filteredExpenses)
            Button {
                do {
                    try modelCtx.delete(model: Expense.self, where: #Predicate { expense in expense.id == dbId })
                    filteredExpenses.removeAll(where: { expense in expense.id == dbId})
                    expenseManager.updateTotalAmountOnDeleted(amount: selectedExpense.price, date: selectedExpense.timestamp)
                    dismiss()
                    showAlert = false
                } catch {
                    showAlert = true
                }
                
                
            } label: {
                Text("DELETE EXPENSE")
                    .foregroundColor(.red)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Failed to delete expense: \(selectedExpense.name)"))
            }
        }
    }
}
