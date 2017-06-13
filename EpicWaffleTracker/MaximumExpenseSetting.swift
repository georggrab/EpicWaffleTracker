//
//  MaximumExpenseSetting.swift
//  EpicWaffleTracker
//
//  Created by Georg Grab on 13.06.17.
//  Copyright © 2017 Epic Waffle Org. All rights reserved.
//

import Foundation
import UIKit
import TSCurrencyTextField
import Toast_Swift

class MaximumExpenseSetting : UIViewController {
    let defaults = UserDefaults.standard
    let props = (UIApplication.shared.delegate as! AppDelegate).properties
    
    @IBAction func saveAndExitAction(_ sender: Any) {
        let toSave = currencyAmount.amount.doubleValue
        
        NSLog("Save And Exit with Expense: \(toSave)")
        defaults.set(toSave, forKey: "MaximumExpense")
        
        insultConditionally(amount: toSave)
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var currencyAmount: TSCurrencyTextField!
    override func viewDidLoad() {
        if let savedAmount = self.defaults.object(forKey: "MaximumExpense") {
            currencyAmount.amount = NSNumber.init(value: savedAmount as! Double)
        }
    }
    
    func insultConditionally(amount amt: Double) {
        guard (props != nil) else {
            return
        }
    
        let poorAmt = props!["insult.poor-threshhold"] as? NSNumber
        let richAmt = props!["insult.rich-threshhold"] as? NSNumber

        guard let poor = poorAmt?.doubleValue else { return }
        guard let rich = richAmt?.doubleValue else { return }
        
        if amt < poor {
            performInsult(text: "Damn, you poor dude!")
        } else if amt >= poor && amt <= rich {
            performInsult(text: "Damn, you so normal dude!")
        } else if amt > rich {
            performInsult(text: "Damn you rich y u even using this shitty App?")
        }
    }
    
    func performInsult(text t: String) {
        self.presentingViewController?.view.makeToast(t)
    }
}
