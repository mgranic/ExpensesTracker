//
//  EditExpenseView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 25.12.2023..
//

import SwiftUI

struct EditExpenseView: View {
    
    //@Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
   // @Binding var isPresentSheet: Bool
    @State var name: String = ""
    @State var price: Double?
    @State var category: Category = Category.none
    @State var date: Date = Date()
    @StateObject var expenseHandler: ExpenseHandler

    var body: some View {
        VStack {
            CreateEditExpenseFormView(name: $name, price: $price, category: $category, date: $date, expenseHandler: _expenseHandler)
            Button {
                if let dbId = expenseHandler.selectedExpense?.dbId {
                    expenseHandler.deleteExpense(id: dbId)
                }
                dismiss()
            } label: {
                Text("DELETE EXPENSE")
                    .foregroundColor(.red)
            }
        }
    }
}
