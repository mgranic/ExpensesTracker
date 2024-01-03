//
//  SettingsView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 01.01.2024..
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("This is settings view")
        }
        .toolbar {
            Menu {
                NavigationLink(destination:HomePageView()) {
                    Text("Home Page")
                }
                NavigationLink(destination: ExpenseStatsView()) {
                    Text("Expense Stats")
                }
            } label: {
                Label("Menu", systemImage: "ellipsis.circle")
                    .foregroundColor(.black)
            }
        }
        
    }
}

#Preview {
    SettingsView()
}
