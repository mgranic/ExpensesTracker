//
//  CreateEditExpenseFormVIew.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 29.12.2023..
//

import SwiftUI

struct CreateEditExpenseFormView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var isPresentSheet: Bool
    @Binding var name: String
    @Binding var price: Double?
    @Binding var category: Category
    @Binding var date: Date
    @StateObject var expenseHandler: ExpenseHandler
    private var isEditView: Bool
    
    // default initializer
    init(isPresent: Binding<Bool>, name: Binding<String>, price: Binding<Double?>, category: Binding<Category>, date: Binding<Date>, expenseHandler: StateObject<ExpenseHandler>, isEdit: Bool) {
        self._isPresentSheet = isPresent
        self._expenseHandler = expenseHandler
        self._name = name
        self._price = price
        self._category = category
        self._date = date
        self.isEditView = isEdit
    }
    
    // edit expense initializer
    init(name: Binding<String>, price: Binding<Double?>, category: Binding<Category>, date: Binding<Date>, expenseHandler: StateObject<ExpenseHandler>) {
        self.init(isPresent: .constant(true), name: name, price: price, category: category, date: date, expenseHandler: expenseHandler, isEdit: true)
    }
    
    // create expense initializer
    init(isPresent: Binding<Bool>, name: Binding<String>, price: Binding<Double?>, category: Binding<Category>, date: Binding<Date>, expenseHandler: StateObject<ExpenseHandler>) {
        self.init(isPresent: isPresent, name: name, price: price, category: category, date: date, expenseHandler: expenseHandler, isEdit: false)
    }
    
    var body: some View {
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
                            if (isEditView) {
                                if let dbId = expenseHandler.selectedExpense?.dbId {
                                    expenseHandler.editExpense(id: dbId, name: name, price: price!, category: category, timestamp: date)
                                }
                                dismiss()
                            } else {
                                expenseHandler.createExpense(name: name, price: price!, category: category, date: date)
                                isPresentSheet = false
                            }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .buttonBorderShape(.capsule)
                    }
                    .disabled(self.name.isEmpty || (self.category == Category.none) || (self.price == nil))
                    Button("Cancel") {
                        if (isEditView) {
                            dismiss()
                        } else {
                            isPresentSheet = false
                        }
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .buttonBorderShape(.capsule)
                }
            }
        }
    }
}
