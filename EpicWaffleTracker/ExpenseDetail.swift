//
//  ExpenseDetail.swift
//  EpicWaffleTracker
//
//  Created by Georg Grab on 12.06.17.
//  Copyright © 2017 Epic Waffle Org. All rights reserved.
//

import Foundation
import UIKit
import CircularSlider

class ExpenseDetail : UIViewController {
    public var passedExpense: Expense!
    public var sendDeleteRequestEvent: ((Expense) -> Void)!
    
    @IBOutlet var expenseAmount: CircularSlider!
    @IBOutlet var expenseName: UILabel!
    @IBOutlet var expenseDate: UILabel!
    @IBOutlet var goEditExpense: UIBarButtonItem!
    
    @IBOutlet var expenseInfo: UILabel!
    @IBAction func goEditExpense(_ sender: Any) {
        performSegue(withIdentifier: "NewExpense", sender: passedExpense)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewExpense" {
            NSLog("Preparing for Expense Edit")
            let newExpense = segue.destination as! NewExpense
            newExpense.editItem = passedExpense
        }
    }

    @IBAction func doSelfDestroy(_ sender: Any) {
        self.sendDeleteRequestEvent(passedExpense)
        self.dismiss(animated: true)
    }
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true)
    }

    func getFormattedDate(_ date: NSDate) -> String? {
        let dFmt = DateFormatter()
        dFmt.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
        return dFmt.string(from: date as Date)
    }
    
    func setInfoTest(_ maxExpense: Double) {
        let nFmt = NumberFormatter()
        nFmt.maximumFractionDigits = 2
        nFmt.minimumFractionDigits = 2
        nFmt.roundingMode = .down
        
        let percentage = nFmt.string(from:
            NSNumber.init(value: passedExpense.amount / maxExpense * 100))!
            
        expenseInfo.text = "THIS ACCOUNTS FOR \(percentage)% OF YOUR MONTHLY BUDGET."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        expenseName.text = passedExpense.title
        expenseDate.text = getFormattedDate(passedExpense.date!)
        
        guard let savedAmount = UserDefaults.standard.object(forKey: "MaximumExpense") else {
            return
        }
        
        let maxExpense = savedAmount as! Double
        expenseAmount.maximumValue = Float(maxExpense)
        
        setInfoTest(maxExpense)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        expenseAmount.setValue(Float(passedExpense.amount), animated: true)
    }
}
