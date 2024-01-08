//
//  SearchView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 08.01.2024..
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @StateObject var searchManager: SearchManager
    @State var category = Category.none
    @State var name: String = ""
    @State var priceFrom: Double = 0.0
    @State var priceTo: Double = 1000000.0
    @State var dateFrom: Date = Date()
    @State var dateTo: Date = Date()
    @State var filteredExpenses: [Expense] = []
    @State var selectedExpense: Expense?
    //@StateObject var expenseManager = ExpenseManager()
    
    init(modelCtx: ModelContext) {
        self._searchManager = StateObject(wrappedValue: SearchManager(modelContext: modelCtx))
    }
    
    var body: some View {
        VStack {
            Form {
                HStack(alignment: .center) {
                    Text("Name")
                    TextField("Name", text: $name)
                        .onChange(of: name, {searchManager.getFilteredExpenseList(name: name, category: category.rawValue, priceFrom: priceFrom, priceTo: priceTo, dateFrom: dateFrom, dateTo: dateTo)})
                }
                HStack(alignment: .center) {
                    Text("Price from")
                    TextField("Price", value: $priceFrom, format: .number)
                        .onChange(of: priceFrom, {searchManager.getFilteredExpenseList(name: name, category: category.rawValue, priceFrom: priceFrom, priceTo: priceTo, dateFrom: dateFrom, dateTo: dateTo)})
                        .keyboardType(.decimalPad)
                }
                HStack(alignment: .center) {
                    Text("Price to")
                    TextField("Price", value: $priceTo, format: .number)
                        .onChange(of: priceTo, {searchManager.getFilteredExpenseList(name: name, category: category.rawValue, priceFrom: priceFrom, priceTo: priceTo, dateFrom: dateFrom, dateTo: dateTo)})
                        .keyboardType(.decimalPad)
                }
                Picker("Category:", selection: $category) {
                    ForEach(Category.allCases, id: \.self) { cat in
                        Text("\(cat.rawValue)").tag(cat.rawValue)
                    }
                }
                .onChange(of: category, {searchManager.getFilteredExpenseList(name: name, category: category.rawValue, priceFrom: priceFrom, priceTo: priceTo, dateFrom: dateFrom, dateTo: dateTo)})
                DatePicker (
                    "From",
                    selection: $dateFrom,
                    displayedComponents: [.date]
                )
                .onChange(of: dateFrom, {searchManager.getFilteredExpenseList(name: name, category: category.rawValue, priceFrom: priceFrom, priceTo: priceTo, dateFrom: dateFrom, dateTo: dateTo)})
                DatePicker (
                    "To",
                    selection: $dateTo,
                    displayedComponents: [.date]
                )
                .onChange(of: dateTo, {searchManager.getFilteredExpenseList(name: name, category: category.rawValue, priceFrom: priceFrom, priceTo: priceTo, dateFrom: dateFrom, dateTo: dateTo)})
            }
            
            List {
                ForEach(searchManager.expenseList) { expense in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(expense.name)")
                                .font(.title3)
                            Text("\(expense.category)")
                        }
                        Spacer()
                        Text("\(expense.price, specifier: "%.2f") €")
                            .font(.title3)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // store selected expense into selectedExpense so that it can be edited
                        //expenseManager.selectedExpense = expense
                        selectedExpense = expense
                        //expenseManager.filteredExpenses = searchManager.expenseList
                    }
                }
            }
            .listStyle(.inset)
            .sheet(item: $selectedExpense) { expense in // show edit expense sheet
                EditExpenseView(dbId: expense.id, filteredExpenses: $searchManager.expenseList, selectedExpense: expense)
            }
        }
    }
}
