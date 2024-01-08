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
    
    var dbId: UUID
    @State var showAlert: Bool = false
    @ObservedObject var expenseManager: ExpenseManager
    
    var body: some View {
        VStack {
            CreateEditExpenseFormView(expenseManager: _expenseManager)
            Button {
                do {
                    try modelCtx.delete(model: Expense.self, where: #Predicate { expense in expense.id == dbId })
                    expenseManager.filteredExpenses.removeAll(where: { expense in expense.id == dbId})
                    expenseManager.setTotalSpent(amount: expenseManager.selectedExpense!.price * (-1), date: expenseManager.selectedExpense!.timestamp)
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
                Alert(title: Text("Failed to delete expense: \(expenseManager.selectedExpense!.name)"))
            }
        }
        .background(Color.black)
    }
}
