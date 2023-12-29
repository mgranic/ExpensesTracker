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

    @State var name: String = ""
    @State var price: Double?
    @State var category: String = Category.none.rawValue
    @State var date: Date = Date()
    @StateObject var expenseHandler: ExpenseHandler

    var body: some View {
        VStack {
            CreateEditExpenseFormView(name: $name, price: $price, category: $category, date: $date, expenseHandler: _expenseHandler)
            Button {
                if let dbId = expenseHandler.selectedExpense?.id {
                    //expenseHandler.deleteExpense(id: dbId)
                    try! modelCtx.delete(model: Expense.self, where: #Predicate { expense in expense.id == dbId })
                }
                dismiss()
            } label: {
                Text("DELETE EXPENSE")
                    .foregroundColor(.red)
            }
        }
    }
}
