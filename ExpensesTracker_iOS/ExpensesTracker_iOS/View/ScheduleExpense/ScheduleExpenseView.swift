//
//  ScheduleExpenseView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 12.01.2024..
//

import SwiftUI
import SwiftData

struct ScheduleExpenseView: View {
    
    @Environment(\.modelContext) var modelCtx
    @Query(sort: \ScheduledExpense.name) var scheduledExpenses: [ScheduledExpense]
    @State var showCreateExpenseSheet: Bool = false
    @State var selectedExpense: ScheduledExpense?
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Button(action: {
                    showCreateExpenseSheet.toggle()
                }) {
                    Text("Schedule expense")
                        .font(.system(.title2, design: .rounded))
                    Image(systemName: "plus.circle.fill")
                }
                .sheet(isPresented: $showCreateExpenseSheet) {
                    CreateScheduledExpenseView(isPresentSheet: $showCreateExpenseSheet)
                }
                List {
                    ForEach(scheduledExpenses) { expense in
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
                            // store selected scheduled expense into selectedExpense so that it can be edited
                            print("+++++++++++++++++++++++++++++++++++++++")
                            print(expense.id)
                            print(expense.name)
                            print("+++++++++++++++++++++++++++++++++++++++")
                            //selectedExpense = ScheduledExpense(id: expense.id, name: expense.name, price: expense.price, category: expense.category, startDate: expense.startDate, interval: expense.interval, intervalStep: expense.intervalStep, isRecurring: expense.isRecurring, isActive: expense.isActive)
                            selectedExpense = expense
                            print("*************************************")
                            print(selectedExpense!.id)
                            print(selectedExpense!.name)
                            print("*************************************")
                        }
                    }
                }
                .listStyle(.inset)
                .sheet(item: $selectedExpense) { expense in // show edit schedule expense sheet
                    EditScheduledExpenseView(dbId: expense.id, selectedExpense: expense)
                }
            }
        }
        .background(Color.black)
        .toolbar {
            NavigationLink(destination: SearchView(modelCtx: modelCtx)) {
                Image(systemName: "magnifyingglass")
            }
            Menu {
                NavigationLink(destination: ExpenseStatsView()) {
                    Text("Expense Stats")
                }
                NavigationLink(destination: ScheduleExpenseView()) {
                    Text("Schedule expense")
                }
                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                }
            } label: {
                Label("Menu", systemImage: "ellipsis.circle")
                    .foregroundColor(.black)
            }
        }
    }
}

#Preview {
    ScheduleExpenseView()
}
