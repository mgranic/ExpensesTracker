//
//  EditScheduledExpenseView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 12.01.2024..
//

import SwiftUI

struct EditScheduledExpenseView: View {
    @State var showAlert: Bool = false
    var body: some View {
        CreateEditScheduleForm()
        
        Button {
            //do {
            //    try modelCtx.delete(model: Expense.self, where: #Predicate { expense in expense.id == dbId })
            //    filteredExpenses.removeAll(where: { expense in expense.id == dbId})
            //    let priceCalculator = PriceCalculator()
            //    priceCalculator.setTotalSpent(amount: selectedExpense.price * (-1), date: selectedExpense.timestamp)
            //    dismiss()
            //    showAlert = false
            //} catch {
            //    showAlert = true
            //}
        } label: {
            Text("DELETE TASK")
                .foregroundColor(.red)
        }
        .alert(isPresented: $showAlert) {
            //Alert(title: Text("Failed to delete expense: \(selectedExpense.name)"))
            Alert(title: Text("Failed to delete task."))
        }
    }
}

#Preview {
    EditScheduledExpenseView()
}
