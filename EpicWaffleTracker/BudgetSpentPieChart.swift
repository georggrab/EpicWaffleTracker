//
//  BudgetSpentPieChart.swift
//  EpicWaffleTracker
//
//  Created by Georg Grab on 14.06.17.
//  Copyright © 2017 Epic Waffle Org. All rights reserved.
//

import Foundation
import CoreData
import Charts

public func getData(coreData data: NSManagedObjectContext) -> PieChartData? {
    let pieData = PieChartData()
    guard let dataSet = getDataSet(coreData: data) else {
        return nil
    }
    
    pieData.addDataSet(dataSet)
    return pieData
}

fileprivate func isWithinThisMonth(_ date: Date) -> Bool {
    let today = Date()
    let fmt = DateFormatter()
    fmt.setLocalizedDateFormatFromTemplate("MMMM-YYYY")
    
    return fmt.string(from: today) == fmt.string(from: date)
}

fileprivate func getDataSet(coreData context: NSManagedObjectContext) -> PieChartDataSet? {
    do {
        let expenseList = try context.fetch((Expense.fetchRequest())) as! [Expense]
        let expensesThisMonth =
            expenseList.filter { isWithinThisMonth($0.date as Date!) }
        
        let allExpensesThisMonth = expensesThisMonth.reduce(0.0, {$0 + $1.amount})
        
        guard let savedAmount = UserDefaults.standard.object(forKey: "MaximumExpense") else {
            return nil
        }
        
        let maximumExpensesForMonth = savedAmount as! Double
        let chartDataSet = PieChartDataSet.init()
        
        if allExpensesThisMonth > maximumExpensesForMonth {
            chartDataSet.colors = ChartColorTemplates.colorful()
            _ = chartDataSet.addEntry(PieChartDataEntry(
                value: allExpensesThisMonth, label: "Budget Exceeded"))
        } else {
            chartDataSet.colors = ChartColorTemplates.material()
            _ = chartDataSet.addEntry(PieChartDataEntry(
                value: allExpensesThisMonth, label: "Used"))
            _ = chartDataSet.addEntry(PieChartDataEntry(
                value: maximumExpensesForMonth - allExpensesThisMonth, label: "Remaining"))
        }

        return chartDataSet
        
    } catch {
        NSLog("Fetching Expenses failed")
        return nil
    }
}

public func configureChart(pieChart view: PieChartView) {
    let today = Date()
    let fmt = DateFormatter()
    fmt.setLocalizedDateFormatFromTemplate("MMMM")

    view.legend.enabled = false
    view.holeRadiusPercent = 0.33
    view.holeColor = UIColor.lightGray
    view.chartDescription?.text = "Remaining Money for \(fmt.string(from: today))"
}
