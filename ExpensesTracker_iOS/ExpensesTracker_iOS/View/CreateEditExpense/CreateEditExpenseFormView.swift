//
//  CreateEditExpenseFormVIew.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 29.12.2023..
//

import SwiftUI

struct CreateEditExpenseFormView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelCtx
    
    @Binding var isPresentSheet: Bool
    @State var name: String = ""
    @State var price: Double
    @State var category: String
    @State var date: Date
    var selectedExpense: Expense
    private var isEditView: Bool
    
    // default initializer
    init(isPresent: Binding<Bool>, isEdit: Bool, selectedExpense: Expense) {
        self._isPresentSheet = isPresent
        self._name = State(initialValue: selectedExpense.name)
        self._price = State(initialValue: selectedExpense.price)
        self._category = State(initialValue: selectedExpense.category)
        self._date = State(initialValue: selectedExpense.timestamp)
        self.isEditView = isEdit
        self.selectedExpense = selectedExpense
    }
    
    // edit expense initializer
    init(selectedExpense: Expense) {
        self.init(isPresent: .constant(false), isEdit: true, selectedExpense: selectedExpense)
    }
    
    // create expense initializer
    init(isPresent: Binding<Bool>, selectedExpense: Expense) {
        self.init(isPresent: isPresent, isEdit: false, selectedExpense: selectedExpense)
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
                                selectedExpense.name = name
                                selectedExpense.price = price
                                selectedExpense.category = category
                                selectedExpense.timestamp = date
                                dismiss()
                            } else {
                                modelCtx.insert(Expense(price: price, name: name, category: category, timestamp: date))
                                isPresentSheet = false
                            }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .buttonBorderShape(.capsule)
                    }
                    .disabled(self.name.isEmpty || (self.category == Category.none.rawValue))
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
