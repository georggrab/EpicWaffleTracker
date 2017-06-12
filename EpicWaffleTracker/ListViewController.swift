//
//  ViewController.swift
//  EpicWaffleTracker
//
//  Created by Patrick Seiter on 08.05.17.
//  Copyright © 2017 Epic Waffle Org. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key:"date", ascending:true) ]
        
        let coreData = CoreData.getInstance()
        let managedObjectContext = coreData.createManagedObjectContext()
        results = try! managedObjectContext.fetch(fetchRequest) as! [Entry]
    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    var results = [Entry]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        
        cell.textLabel?.text = results[indexPath.row].text
        cell.detailTextLabel?.text = "\(results[indexPath.row].amount)$"
        
        return cell
    }
    
    @IBAction func newclick(_ sender: UIButton) {
        let coreData = CoreData.getInstance()
        let managedObjectContext = coreData.createManagedObjectContext()
        
        let person = NSEntityDescription.insertNewObject(forEntityName: "Entry",
                                                         into:managedObjectContext) as! Entry
        do {
            try managedObjectContext.save()
        }
        catch{}
        
        person.text = "New Entry"
        person.date = NSDate()
        person.amount = 0.00
        
        results.append(person)
        
        self.tableView.reloadData()
    }
}




