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
    var expenseList: [Expense] = []
    var selectedExpense : Expense!
    
    @IBOutlet var expenses: UITableView!
    @IBAction func navigateBack(_ sender: Any) {
        self.dismiss(animated: true) { }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenses.delegate = self
        expenses.dataSource = self
    }
    
    func getAndLoadData() {
        getData()
        expenses.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAndLoadData()
    }
    
    func getData() {
        do {
            expenseList = try context.fetch((Expense.fetchRequest()))
        } catch {
            NSLog("Fetching Expenses failed")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let expense = expenseList[indexPath.row]
        
        if let myName = expense.title {
            cell.textLabel?.text = myName
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("Cell Selected: \(indexPath.row)")
        
        let index = expenses.indexPathForSelectedRow!
        selectedExpense = expenseList[index.row]
        
        performSegue(withIdentifier: "DetailExpense", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DetailExpense") {
            let expenseDetail = segue.destination as! ExpenseDetail
            expenseDetail.passedExpense = selectedExpense
            expenseDetail.sendDeleteRequestEvent = self.handleDeleteEvent
        }
    }
    
    func handleDeleteEvent(_ expense: Expense) {
        NSLog("DetailView sent DeleteEvent")
        let match = expenseList.first { (e: Expense) -> Bool in
            e == expense
        }
        if let hit = match {
            context.delete(hit)
            getAndLoadData()
        } else {
            NSLog("Something is wrong: expense passed from DetailView is not available in our Root Data Store! Reloading Cached Core Data Structure.")
            getAndLoadData()
        }
    }
    
}
