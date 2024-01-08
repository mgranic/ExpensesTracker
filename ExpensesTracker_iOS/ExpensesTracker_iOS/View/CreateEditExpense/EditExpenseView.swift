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
    @Binding var filteredExpenses: [Expense]
    var selectedExpense: Expense
    
    var body: some View {
        VStack {
            CreateEditExpenseFormView(filteredExpenses: $filteredExpenses, selectedExpense: selectedExpense)
            Button {
                do {
                    try modelCtx.delete(model: Expense.self, where: #Predicate { expense in expense.id == dbId })
                    filteredExpenses.removeAll(where: { expense in expense.id == dbId})
                    let priceCalculator = PriceCalculator()
                    priceCalculator.setTotalSpent(amount: selectedExpense.price * (-1), date: selectedExpense.timestamp)
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
        .background(Color.black)
    }
}
