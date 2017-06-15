//
//  MainScreen.swift
//  EpicWaffleTracker
//
//  Created by Georg Grab on 12.06.17.
//  Copyright © 2017 Epic Waffle Org. All rights reserved.
//

import Foundation
import UIKit
import Charts

class MainScreen : UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var budgetSpentChart: PieChartView!
    
    override func viewDidLoad() {
        configureChart(pieChart: budgetSpentChart)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        budgetSpentChart.data = getData(coreData: context)
    }
}
