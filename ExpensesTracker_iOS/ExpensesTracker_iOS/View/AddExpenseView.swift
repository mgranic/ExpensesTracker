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
    @State var category: Category = Category.caffe
    @StateObject var expenseHandler: ExpenseHandler

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Name")
                    .frame(maxWidth: .infinity, alignment: .center)
                TextField("Name", text: $name)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            HStack(alignment: .center) {
                Text("Price")
                    .frame(maxWidth: .infinity, alignment: .center)
                TextField("Price", value: $price, format: .number)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            HStack(alignment: .center) {
                Picker("Category:", selection: $category) {
                    ForEach(Category.allCases, id: \.self) { cat in
                        Text("\(cat.rawValue)").tag(cat.rawValue)
                    }
                }
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            
            HStack {
                Button("Submit") {
                    expenseHandler.createExpense(name: name, price: price, category: category)
                    isPresentSheet = false
                }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .buttonBorderShape(.capsule)
                Button("Cancel") {
                    isPresentSheet = false
                }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .buttonBorderShape(.capsule)
            }
        }
    }
}
