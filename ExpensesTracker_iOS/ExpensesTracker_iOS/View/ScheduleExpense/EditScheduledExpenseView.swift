//
//  EditScheduledExpenseView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 12.01.2024..
//

import SwiftUI

struct EditScheduledExpenseView: View {
    @Environment(\.modelContext) var modelCtx
    @Environment(\.dismiss) var dismiss
    
    @State var showAlert: Bool = false
    var dbId: UUID
    var selectedExpense: ScheduledExpense
    
    init(dbId: UUID, selectedExpense: ScheduledExpense) {
        self.dbId = dbId
        self.selectedExpense = selectedExpense
    }
    
    
    
    
    var body: some View {
        CreateEditScheduleForm(isEdit: true, selectedExpense: selectedExpense)
        
        Button {
            do {
                try modelCtx.delete(model: ScheduledExpense.self, where: #Predicate { expense in expense.id == dbId })
                dismiss()
                showAlert = false
            } catch {
                showAlert = true
            }
        } label: {
            Text("DELETE TASK")
                .foregroundColor(.red)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Failed to delete expense: \(selectedExpense.name)"))
        }
    }
}
