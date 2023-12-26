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
    
    @Binding var isPresentSheet: Bool
    @State var name: String = ""
    @State var price: Double?
    @State var category: Category = Category.none
    @State var date: Date = Date()
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
                    DatePicker (
                        "Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                }
                
                Section {
                    HStack {
                        Section {
                            Button("Submit") {
                                
                                if let dbId = expenseHandler.selectedExpense?.dbId {
                                    expenseHandler.editExpense(id: dbId, name: name, price: price!, category: category, timestamp: date)
                                }
                                
                                //expenseHandler.editExpense(id: expenseHandler.selectedExpense?.dbId!, name: name, price: price!, category: category)
                                //self.presentationMode.wrappedValue.dismiss()
                                dismiss()
                                //isPresentSheet = false
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                            .buttonBorderShape(.capsule)
                        }
                        .disabled(name.isEmpty || (category == Category.none) || (price == nil))
                        Button("Cancel") {
                            //print("2) --- \(expenseHandler.selectedExpense?.name)")
                            //self.presentationMode.wrappedValue.dismiss()
                            dismiss()
                            //isPresentSheet = false
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .buttonBorderShape(.capsule)
                    }
                }
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
}
