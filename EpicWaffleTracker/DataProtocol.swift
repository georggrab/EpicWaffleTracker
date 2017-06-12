//
//  DataProtocol.swift
//  EpicWaffleTracker
//
//  Created by Georg Grab on 12.06.17.
//  Copyright © 2017 Epic Waffle Org. All rights reserved.
//

import Foundation

protocol DataProtocol {
    func isDataStorePopulated() -> Bool
    func getAllExpenses() -> [Expense]
}
