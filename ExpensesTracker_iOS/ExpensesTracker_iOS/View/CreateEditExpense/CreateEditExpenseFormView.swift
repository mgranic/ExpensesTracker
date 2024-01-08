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
    //@Binding var filteredExpenses: [Expense]
    @ObservedObject var expenseManager: ExpenseManager
    //var selectedExpense: Expense
    private var isEditView: Bool
    
    // default initializer
    init(isPresent: Binding<Bool>, isEdit: Bool, expenseManager: ObservedObject<ExpenseManager> = ObservedObject(initialValue: ExpenseManager())) {
        self._isPresentSheet = isPresent
        // if this is new expense selectedExpense is nil
        let selectedExpense = expenseManager.wrappedValue.selectedExpense ?? Expense(price: 0.0, name: "", category: Category.none.rawValue, timestamp: Date())
        self._name = State(initialValue: selectedExpense.name)
        self._price = State(initialValue: selectedExpense.price)
        self._category = State(initialValue: selectedExpense.category)
        self._date = State(initialValue: selectedExpense.timestamp)
        self.isEditView = isEdit
        //self.selectedExpense = selectedExpense
        //self._filteredExpenses = filteredExpenses
        self._expenseManager = expenseManager
    }
    
    // edit expense initializer
    init(expenseManager: ObservedObject<ExpenseManager>) {
        self.init(isPresent: .constant(false), isEdit: true, expenseManager: expenseManager)
    }
    
    // create expense initializer
    init(isPresent: Binding<Bool>, expenseManager: ObservedObject<ExpenseManager>) {
        self.init(isPresent: isPresent, isEdit: false, expenseManager: expenseManager)
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
                            if (isEditView) { // edit expense
                                //expenseManager.setTotalSpent(amount: <#T##Double#>, date: Date)
                                expenseManager.setTotalSpentOnEdit(oldAmount: expenseManager.selectedExpense!.price, newAmount: price, oldDate: expenseManager.selectedExpense!.timestamp, newDate: date)
                                expenseManager.selectedExpense!.name = name
                                expenseManager.selectedExpense!.price = price
                                expenseManager.selectedExpense!.category = category
                                expenseManager.selectedExpense!.timestamp = date
                                dismiss()
                            } else { // add new expense
                                let newExpense = Expense(price: price, name: name, category: category, timestamp: date)
                                modelCtx.insert(newExpense)
                                expenseManager.filteredExpenses.append(newExpense)
                                expenseManager.setTotalSpent(amount: newExpense.price, date: newExpense.timestamp)
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
        .background(Color.black)
    }
}
