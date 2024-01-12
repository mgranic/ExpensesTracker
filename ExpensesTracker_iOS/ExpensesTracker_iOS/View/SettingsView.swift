//
//  SettingsView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 01.01.2024..
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) var modelCtx
    @State var showAlert: Bool = false
    var body: some View {
        VStack {
            Button("Factory reset") {
                let settingsManager = SettingManager()
                settingsManager.resetUserDefaults(modelContext: modelCtx, showAlert: &showAlert)
            }
            .buttonStyle(.borderedProminent)
        }
        .background(Color.black)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Failed to reset all user data"))
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
