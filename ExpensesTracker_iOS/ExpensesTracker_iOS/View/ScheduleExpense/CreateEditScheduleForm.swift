//
//  CreateEditScheduleForm.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 12.01.2024..
//

import SwiftUI

struct CreateEditScheduleForm: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelCtx
    @Binding var isPresentSheet: Bool
    
    @State var name: String = ""
    @State var price: Double = 0.0
    @State var category: Category = Category.none
    @State var interval: ExpenseInterval = ExpenseInterval.month
    @State var startDate: Date = Date()
    
    private var isEditView: Bool
    private var selectedExpense: ScheduledExpense
    private var dateFrom = Date()...
    
    init(isPresent: Binding<Bool> = .constant(true), isEdit: Bool = false, selectedExpense: ScheduledExpense = ScheduledExpense(name: "", price: 0.0, category: Category.none.rawValue)) {
        self._isPresentSheet = isPresent
        self.isEditView = isEdit
        self._name = State(initialValue: selectedExpense.name)
        self._price = State(initialValue: selectedExpense.price)
        self._category = State(initialValue: Category(rawValue: selectedExpense.category) ?? Category.none)
        self._interval = State(initialValue: ExpenseInterval(rawValue: selectedExpense.interval) ?? ExpenseInterval.month)
        self._startDate = State(initialValue: selectedExpense.startDate)
        self.selectedExpense = selectedExpense
    }
    
    var body: some View {
        NavigationStack {
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
                        selection: $startDate,
                        in: dateFrom,
                        displayedComponents: [.date]
                    )
                }
                Section {
                    HStack(alignment: .center) {
                        Picker("Interval:", selection: $interval) {
                            //ForEach(ExpenseInterval.allCases, id: \.self) { interval in
                            //    Text("\(interval.rawValue)").tag(interval.rawValue)
                            //}
                            Text("\(ExpenseInterval.month.rawValue)").tag(ExpenseInterval.month)
                            Text("\(ExpenseInterval.year.rawValue)").tag(ExpenseInterval.year)
                        }
                    }
                }
                Section {
                    HStack {
                        Section {
                            Button("Schedule expense") {
                                if (isEditView) { // edit scheduled expense
                                    selectedExpense.name = name
                                    selectedExpense.price = price
                                    selectedExpense.category = category.rawValue
                                    selectedExpense.interval = interval.rawValue
                                    selectedExpense.startDate = startDate
                                    dismiss()
                                } else { // add new scheduled expense
                                    let scheduleMgr = ScheduleExpenseManager(modelCtx: modelCtx)
                                    let scheduledExpense = ScheduledExpense(name: name, price: price, category: category.rawValue, startDate: startDate, interval: interval.rawValue)
                                    scheduleMgr.createScheduledExpense(scheduledExpense: scheduledExpense)
                                    isPresentSheet = false
                                    
                                    let scheduleExpenseManager = ScheduleExpenseManager(modelCtx: modelCtx)
                                    scheduleExpenseManager.createScheduledExpenses(scheduledExpense: scheduledExpense)
                                }
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                            .buttonBorderShape(.capsule)
                        }
                        .disabled(self.name == "" || (self.category == Category.none))
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
        .background(Color.black)
    }
}

#Preview {
    CreateEditScheduleForm()
}
