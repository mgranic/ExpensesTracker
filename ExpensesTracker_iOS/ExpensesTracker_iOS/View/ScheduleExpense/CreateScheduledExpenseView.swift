//
//  CreateScheduledExpenseView.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 12.01.2024..
//

import SwiftUI

struct CreateScheduledExpenseView: View {
    @Binding var isPresentSheet: Bool
    var body: some View {
        CreateEditScheduleForm(isPresent: $isPresentSheet)
    }
}
