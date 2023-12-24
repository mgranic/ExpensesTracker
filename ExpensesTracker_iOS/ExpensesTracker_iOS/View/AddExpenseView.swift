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
    @StateObject var expenseHandler: ExpenseHandler

    var body: some View {
        VStack {
            Form {
                Section {
                    HStack(alignment: .center) {
                        Text("Name")
                        TextField("Name", text: $name)
                    }
                    HStack(alignment: .center) {
                        Text("Price")
                        TextField("Price", value: $price, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    HStack(alignment: .center) {
                        Picker("Category:", selection: $category) {
                            ForEach(Category.allCases, id: \.self) { cat in
                                Text("\(cat.rawValue)").tag(cat.rawValue)
                            }
                        }
                    }
                }
                
                Section {
                    HStack {
                        Section {
                            Button("Submit") {
                                expenseHandler.createExpense(name: name, price: price!, category: category)
                                isPresentSheet = false
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                            .buttonBorderShape(.capsule)
                        }
                        .disabled(name.isEmpty || (category == Category.none) || (price == nil))
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
    }
}
