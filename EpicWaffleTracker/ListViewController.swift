//
//  ViewController.swift
//  EpicWaffleTracker
//
//  Created by Patrick Seiter on 08.05.17.
//  Copyright © 2017 Epic Waffle Org. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var fruits = ["Apple", "Apricot", "Banana", "Blueberry", "Cantaloupe", "Cherry",
              "Clementine", "Coconut", "Cranberry", "Fig", "Grape", "Grapefruit",
              "Kiwi fruit", "Lemon", "Lime", "Lychee", "Mandarine", "Mango",
              "Melon", "Nectarine", "Olive", "Orange", "Papaya", "Peach",
              "Pear", "Pineapple", "Raspberry", "Strawberry"]
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        
        cell.textLabel?.text = fruits[indexPath.row]
        
        return cell
    }
}




