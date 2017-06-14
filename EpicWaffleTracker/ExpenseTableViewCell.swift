//
//  ExpenseTableViewCell.swift
//  EpicWaffleTracker
//
//  Created by Georg Grab on 14.06.17.
//  Copyright © 2017 Epic Waffle Org. All rights reserved.
//

import Foundation
import UIKit

class ExpenseTableViewCell : UITableViewCell {
    @IBOutlet var expenseTitle: UILabel!

    @IBOutlet var expenseAmount: UILabel!
    
    public func set(title t: String?) {
        expenseTitle.text = t
    }
    
    public func set(currency c: NSNumber) {
        let n = NumberFormatter()
        n.numberStyle = .currency
        expenseAmount.text = n.string(from: c)
    }
    
    public func set(detail d: String?) {
        expenseAmount.text = d
    }
}
