//
//  NewExpense.swift
//  EpicWaffleTracker
//
//  Created by Georg Grab on 12.06.17.
//  Copyright © 2017 Epic Waffle Org. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
import TSCurrencyTextField
import FSCalendar

class NewExpense : UIViewController {
    public var editItem: Expense?
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var expenseName: UITextField!
    @IBOutlet var expenseAmount: TSCurrencyTextField!
    @IBOutlet var Calendar: FSCalendar!

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true) { }
    }
    
    override func viewDidLoad() {
        if let exp = editItem {
           Calendar.select((exp.date as! Date))
            expenseName.text = exp.title
            expenseAmount.amount = NSNumber.init(value: exp.amount)
            navigationBar.topItem?.title = "Edit Expense"
        } else {
            // We'll initialize FSCalendar with
            // today's Date, which is probably
            // what the user wants anyway.
            Calendar.select(Date())
        }
    }
    @IBAction func addClick(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var mutateExpenseEntity : Expense
        
        if let exp = editItem {
            mutateExpenseEntity = exp
        } else {
            mutateExpenseEntity = Expense(context: context)
        }

        mutateExpenseEntity.title = expenseName.text!
        mutateExpenseEntity.amount = expenseAmount.amount.doubleValue
        
        if let date = Calendar.selectedDate {
            mutateExpenseEntity.date = date as NSDate
        }

        NSLog("Saving new expense: \(mutateExpenseEntity.title)")
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        self.presentingViewController?.view.makeToast("Got it!")
        self.dismiss(animated: true) { }

    }
}
