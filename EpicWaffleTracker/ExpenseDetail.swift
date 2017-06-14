//
//  ExpenseDetail.swift
//  EpicWaffleTracker
//
//  Created by Georg Grab on 12.06.17.
//  Copyright © 2017 Epic Waffle Org. All rights reserved.
//

import Foundation
import UIKit

class ExpenseDetail : UIViewController {
    public var passedExpense: Expense!
    public var sendDeleteRequestEvent: ((Expense) -> Void)!
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var cost: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doSelfDestroy(_ sender: Any) {
        self.sendDeleteRequestEvent(passedExpense)
        self.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.topItem?.title = passedExpense.title
        cost.text = "\(passedExpense.amount)$"
        
    }
}
