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
    @IBOutlet var expenseName: UITextField!
    @IBOutlet var expenseAmount: TSCurrencyTextField!
    @IBOutlet var Calendar: FSCalendar!
    
    @IBAction func cancel(_ sender: Any) {
        print("Cancel Add Item")
        self.dismiss(animated: true) { }
    }
    
    override func viewDidLoad() {
        // We'll initialize FSCalendar with
        // today's Date, which is probably
        // what the user wants anyway.
        Calendar.select(Date())
    }
    
    @IBAction func addClick(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let expense = Expense(context: context)
        
        expense.title = expenseName.text!
        expense.amount = expenseAmount.amount.doubleValue
        
        if let date = Calendar.selectedDate {
            expense.date = date as NSDate
        }

        NSLog("Saving new expense: \(expense.title)")
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        self.presentingViewController?.view.makeToast("Got it!")
        self.dismiss(animated: true) { }

    }
}
