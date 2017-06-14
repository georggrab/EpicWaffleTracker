//
//  Expenses.swift
//  EpicWaffleTracker
//
//  Created by Georg Grab on 12.06.17.
//  Copyright © 2017 Epic Waffle Org. All rights reserved.
//

import UIKit

class Expenses : UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var uniqueDates: [(NSDate, Int)] = []
    var expenseList: [Expense] = []
    
    @IBOutlet var expenses: UITableView!
    @IBAction func navigateBack(_ sender: Any) {
        self.dismiss(animated: true) { }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenses.delegate = self
        expenses.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAndLoadData()
    }
    
    func getAndLoadData() {
        getSortedData()
        calculateGroupings()
        expenses.reloadData()
    }

    
    func getSortedData() {
        do {
            expenseList = try context.fetch((Expense.fetchRequest()))
        } catch {
            NSLog("Fetching Expenses failed")
        }
        expenseList.sort { ($0.date! as Date).compare(($1.date!) as Date)
            == ComparisonResult.orderedAscending }
    }
    
    func calculateGroupings() {
        uniqueDates = []
        
        var previousDate : NSDate? = nil
        var atIndex : Int = -1
        
        expenseList.forEach {
            if $0.date != previousDate {
                uniqueDates.append(($0.date!, 1))
                previousDate = $0.date
                atIndex += 1
            } else {
                let tup = uniqueDates[atIndex]
                uniqueDates[atIndex] = (tup.0, tup.1 + 1)
            }
        }
        
        NSLog("Calculated \(uniqueDates.count) Groupings (Criteria: Unique Date)")
    }
    
    /* The row the indexPath returns when building the tableView is
     * relative to the section. Thus, we'll have to calculate the
     * absolute expenseIndex here so we'll be able to look it up in
     * our expenseList dataSource.
     */
    func expenseIndex(via indexPath: IndexPath) -> Int {
        var trueIndex = 0
        var iterator = 0
        while indexPath.section > iterator {
            trueIndex += uniqueDates[iterator].1
            iterator += 1
        }
        
        trueIndex += indexPath.row
        return trueIndex
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return uniqueDates.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dFormat = DateFormatter()
        dFormat.dateFormat = "dd.MM.YYYY"
        
        return dFormat.string(from: uniqueDates[section].0 as Date)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let startIndex =
            expenseIndex(via: IndexPath(row: 0, section: section))
        let endIndex =
            expenseIndex(via: IndexPath(row: uniqueDates[section].1 - 1, section: section))
        
        var total : Double = 0.0
        for i in startIndex ... endIndex {
            total += expenseList[i].amount
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return "\(formatter.string(from: NSNumber.init(value: total))!) were spent that day."
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as! ExpenseTableViewCell
        let expense = expenseList[expenseIndex(via: indexPath)]

        if let myName = expense.title {
            cell.set(title: myName)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        cell.set(currency: NSNumber.init(value: expense.amount))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uniqueDates[section].1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("Cell Selected: \(indexPath.row)")
        performSegue(withIdentifier: "DetailExpense", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "DetailExpense") {
            NSLog("preparing segue")
            let index = expenses.indexPathForSelectedRow!
            let selectedExpense = expenseList[expenseIndex(via: index)]
            
            let expenseDetail = segue.destination as! ExpenseDetail
            
            expenseDetail.passedExpense = selectedExpense
            expenseDetail.sendDeleteRequestEvent = self.handleDeleteEvent
        }
    }
    
    func handleDeleteEvent(_ expense: Expense) {
        NSLog("DetailView sent DeleteEvent")
        let match = expenseList.first { (e: Expense) -> Bool in
            e === expense
        }

        if let hit = match {
            context.delete(hit)
            do {
                try context.save()
            } catch {
                NSLog("Unable to save Context")
            }
            getAndLoadData()
        } else {
            NSLog("Something is wrong: expense passed from DetailView" +
                "is not available in our Root Data Store!" +
                "Reloading Cached Core Data Structure.")
            getAndLoadData()
        }
    }
    
}
