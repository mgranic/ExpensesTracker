//
//  ScheduleExpenseManager.swift
//  ExpensesTracker_iOS
//
//  Created by Mate Granic on 13.01.2024..
//

import Foundation
import SwiftData

class ScheduleExpenseManager {
    
    var modelCtx: ModelContext
    
    init(modelCtx: ModelContext) {
        self.modelCtx = modelCtx
    }
    
    // get all scheduled expenses from database
    func getAllScheduledExpenses() -> [ScheduledExpense] {
        let descriptor = FetchDescriptor<ScheduledExpense>(sortBy: [SortDescriptor(\.name)])
        return try! modelCtx.fetch(descriptor)
    }
    
    // create scheduled expense in databaseÏ
    func createScheduledExpense(scheduledExpense: ScheduledExpense) {
        modelCtx.insert(scheduledExpense)
    }
    
    // go through all scheduled expenses and create expense for the ones that are due for execution
    func executeScheduledExpensesTask() {
        let scheduledExpenses = getAllScheduledExpenses()
        
        // don't waste time and resoures if there are no scheduled expenses
        if (scheduledExpenses.isEmpty) {
            return;
        }
        
        // for each scheduled expense
        for i in 0...(scheduledExpenses.count - 1) {
            // caclulate number of pending executions for given task
            let numOfPendingExecutions = numberOfPendingExecutions(scheduledExpense: scheduledExpenses[i])
                
            // don't waste time if there are no pending executions
            if (numOfPendingExecutions <= 0) {
                continue
            }
                
            let executionDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: scheduledExpenses[i].startDate)
            let calendar = Calendar(identifier: .gregorian)
            //calendar.timeZone = TimeZone(secondsFromGMT: 3600)! // CET timezone
            var year = executionDateComponents.year
            var month = executionDateComponents.month
            
            // if interval is month deduce 1 from month because you will add 1 for each month iteration so 1 is deduced
            // so that first month can be included
            if (scheduledExpenses[i].interval == ExpenseInterval.month.rawValue) {
                month = month! - 1
            } else if (scheduledExpenses[i].interval == ExpenseInterval.year.rawValue) {
                // for the same reason deduce 1 from year
                year = year! - 1
            } else {
                // error
            }
                
            // for each pendind execution
            for _ in 1...numOfPendingExecutions {
                if (scheduledExpenses[i].interval == ExpenseInterval.month.rawValue) {
                    // for each execution, increment month by 1, to have proper timestamp for expense date
                    month = month! + 1
                    // if passing to next year, increment year as well for proper timestamp
                    if (month! > 12) {
                        month = month! - 12
                        year = year! + 1
                    }
                } else if (scheduledExpenses[i].interval == ExpenseInterval.year.rawValue) {
                    // for each execution, increment year by 1, to have proper timestamp for expense date
                    year = year! + 1
                } else {
                    // error
                }
                let components = DateComponents(year: year, month: month, day: executionDateComponents.day)
                
                let newExpense = Expense(price: scheduledExpenses[i].price, name: scheduledExpenses[i].name, category: scheduledExpenses[i].category, timestamp: calendar.date(from: components)!)
                modelCtx.insert(newExpense)
                let priceCalculator = PriceCalculator()
                priceCalculator.setTotalSpent(amount: newExpense.price, date: newExpense.timestamp)
                scheduledExpenses[i].lastExecuted = calendar.date(from: components)!
                scheduledExpenses[i].isFirstExecution = false
            }
        }
    }
    
    // calculate number of executions needed for given scheduled task
    func numberOfPendingExecutions(scheduledExpense: ScheduledExpense) -> Int {
        var numOfExecutions = 0
        let interval = ExpenseInterval(rawValue: scheduledExpense.interval)
        
        let lastExecutedDateComponents = Calendar.current.dateComponents([.day, .weekOfYear, .month, .year], from: scheduledExpense.lastExecuted)
        let scheduledDateComponents = Calendar.current.dateComponents([.day, .weekOfYear, .month, .year], from: scheduledExpense.startDate)
        let currentDateComponents = Calendar.current.dateComponents([.day, .weekOfYear, .month, .year], from: Date())
        
        switch interval {
        case .month:
            
            // task within same year
            if (lastExecutedDateComponents.year! == currentDateComponents.year!) {
                // if we are calulating only for this year, number of pending executions is just number of months that have passed
                numOfExecutions = currentDateComponents.month! - lastExecutedDateComponents.month!
                
                // calculate if this month should be executed as well (due date have passed)
                if (numOfExecutions > 1 && scheduledDateComponents.day! <= currentDateComponents.day!) {
                    numOfExecutions = numOfExecutions + 1
                // if due date have passed and taks have never been executed, execute it immidietly
                } else if ((numOfExecutions == 0) && (scheduledDateComponents.day! <= currentDateComponents.day!) && (scheduledExpense.isFirstExecution == true)) {
                    numOfExecutions = 1
                } else {
                    // error
                }
            } else { // task within past year
                let yearDiff = currentDateComponents.year! - lastExecutedDateComponents.year!
                // if there is more than 1 year difference, multiply each year (above 1 year difference) with 12 (12 months a year)
                numOfExecutions = (yearDiff - 1) * 12
                // for the last year (1 year difference) calculate month difference as in circular buffer (year ends 1uth 12 and starts with 1)
                numOfExecutions = numOfExecutions + (12 - abs(currentDateComponents.month! - lastExecutedDateComponents.month!))
                // check if execution for current month is needed, and it is neded if due date have passed for this mont (day diff)
                if (currentDateComponents.day! >= lastExecutedDateComponents.day!) {
                    numOfExecutions = numOfExecutions + 1
                } else if ((currentDateComponents.day! < lastExecutedDateComponents.day!) && (numOfExecutions > 0) && (scheduledExpense.isFirstExecution == false)) {
                    // if day has not come to execute task and it is not first execution, don't execute it
                    numOfExecutions = 0
                } else {
                    // error
                }
            }
            
        case .year:
            numOfExecutions = currentDateComponents.year! - lastExecutedDateComponents.year!
            
            // if it is new year but it is still not time to execute this task
            if ((numOfExecutions > 0) &&
                ((currentDateComponents.month! < lastExecutedDateComponents.month!) ||
                 ((currentDateComponents.month! == lastExecutedDateComponents.month!) &&
                  (currentDateComponents.day! < lastExecutedDateComponents.day!))) &&
                (scheduledExpense.isFirstExecution == false)) {
                numOfExecutions = numOfExecutions - 1;
            } else if ((numOfExecutions > 0) &&
                       (((currentDateComponents.month! >= lastExecutedDateComponents.month!) &&
                         (currentDateComponents.day! >= lastExecutedDateComponents.day!)))) {
            // check if this year needs to be included into the execution as well
                numOfExecutions = numOfExecutions + 1;
            } else if((numOfExecutions == 0) &&
                      (((scheduledDateComponents.day! <= currentDateComponents.day!) &&
                        (scheduledDateComponents.month! <= currentDateComponents.month!)) &&
                       (scheduledExpense.isFirstExecution == true))) {
            // if it is same year but it is due date for execution (first execution and date and mnth have passed)
                numOfExecutions = 1
            } else {
                // error
            }
                
        default:
            numOfExecutions = 0
        }
        
        return numOfExecutions
    }
    
    // execute imidietly after creating scheduled task right after creation of the task
    // if needed, execute task imidietly
    func createScheduledExpenses(scheduledExpense: ScheduledExpense) {
        let scheduledDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: scheduledExpense.startDate)
        let currentDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        
        // if today is the day of the execution, execute and return
        if ((scheduledDateComponents.day == currentDateComponents.day) &&
            (scheduledDateComponents.month == currentDateComponents.month) &&
            (scheduledDateComponents.year == currentDateComponents.year)) {
            let newExpense = Expense(price: scheduledExpense.price, name: scheduledExpense.name, category: scheduledExpense.category, timestamp: scheduledExpense.startDate)
            modelCtx.insert(newExpense)
            let priceCalculator = PriceCalculator()
            priceCalculator.setTotalSpent(amount: newExpense.price, date: newExpense.timestamp)
            scheduledExpense.lastExecuted = Date()
            scheduledExpense.isFirstExecution = false
        }
    }
}
