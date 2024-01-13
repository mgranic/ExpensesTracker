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
    @State var isRecurring: Bool = false
    @State var intervalStep: Int = 1
    
    private var isEditView: Bool
    private var selectedExpense: ScheduledExpense
    
    init(isPresent: Binding<Bool> = .constant(true), isEdit: Bool = false, selectedExpense: ScheduledExpense = ScheduledExpense(name: "", price: 0.0, category: Category.none.rawValue, intervalStep: 1)) {
        self._isPresentSheet = isPresent
        self.isEditView = isEdit
        self._name = State(initialValue: selectedExpense.name)
        self._price = State(initialValue: selectedExpense.price)
        self._category = State(initialValue: Category(rawValue: selectedExpense.category) ?? Category.none)
        self._interval = State(initialValue: ExpenseInterval(rawValue: selectedExpense.interval) ?? ExpenseInterval.month)
        self._startDate = State(initialValue: selectedExpense.startDate)
        self._isRecurring = State(initialValue: selectedExpense.isRecurring)
        self._intervalStep = State(initialValue: selectedExpense.intervalStep)
        self.selectedExpense = selectedExpense
        print("CreateEditScheduleForm name = \(self.name)")
        print("CreateEditScheduleForm selectedExpense.name = \(selectedExpense.name)")
        print("CreateEditScheduleForm selectedExpense.id = \(selectedExpense.id)")
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
                        displayedComponents: [.date]
                    )
                }
                Section {
                    Toggle(isOn: $isRecurring) {
                        Text("Repeating task")
                    }
                }
                Section {
                    HStack(alignment: .center) {
                        Picker("Interval:", selection: $interval) {
                            ForEach(ExpenseInterval.allCases, id: \.self) { interval in
                                Text("\(interval.rawValue)").tag(interval.rawValue)
                            }
                        }
                    }
                    HStack(alignment: .center) {
                        Text("Interval step")
                        TextField("Interval step", value: $intervalStep, format: .number)
                            .keyboardType(.numberPad)
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
                                    selectedExpense.isRecurring = isRecurring
                                    selectedExpense.startDate = startDate
                                    selectedExpense.intervalStep = intervalStep
                                    dismiss()
                                } else { // add new scheduled expense
                                    let scheduleMgr = ScheduleExpenseManager(modelCtx: modelCtx)
                                    scheduleMgr.createScheduledExpense(scheduledExpense: ScheduledExpense(name: name, price: price, category: category.rawValue, startDate: startDate, interval: interval.rawValue, intervalStep: intervalStep, isRecurring: isRecurring))
                                    isPresentSheet = false
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
