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
    @State var name = ""
    @State var price = 0.0
    @StateObject var expenseHandler: ExpenseHandler

    var body: some View {
        VStack {
            HStack {
                Text("Name")
                TextField("Name", text: $name)
            }
            HStack {
                Text("Price")
                TextField("Price", value: $price, format: .number)
            }

            Button("Submit") {
                expenseHandler.createExpense(name: name, price: price)
                isPresentSheet = false
            }
            Button("Cancel") {
                isPresentSheet = false
            }
        }
    }
}
