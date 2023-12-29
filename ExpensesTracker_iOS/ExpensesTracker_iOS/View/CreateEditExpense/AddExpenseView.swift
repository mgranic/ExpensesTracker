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
    @State var price: Double?
    @State var category: Category = Category.none
    @State var date = Date()
    @StateObject var expenseHandler: ExpenseHandler

    var body: some View {
        VStack {
            CreateEditExpenseFormView(isPresent: $isPresentSheet, name: $name, price: $price, category: $category, date: $date, expenseHandler: _expenseHandler)
        }
    }
}
