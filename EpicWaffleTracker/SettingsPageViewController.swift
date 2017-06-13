//
//  SettingsPageViewController.swift
//  EpicWaffleTracker
//
//  Created by Georg Grab on 13.06.17.
//  Copyright © 2017 Epic Waffle Org. All rights reserved.
//

import Foundation
import UIKit

class SettingsPageViewController : UIPageViewController {
    let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private(set) lazy var settingsViews : [UIViewController] = {
        return [
            self.board.instantiateViewController(withIdentifier: "InputTotalExpense"),
            self.board.instantiateViewController(withIdentifier: "OtherSettings")
        ]
    }()
    
    let idx = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        if let initial = settingsViews.first {
            setViewControllers([initial], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return settingsViews.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

}

extension SettingsPageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = settingsViews.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = index + 1
        
        guard nextIndex < settingsViews.count else {
            return nil
        }
        
        return settingsViews[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = settingsViews.index(of: viewController) else {
            return nil
        }
        
        let prevIndex = index - 1
        
        guard prevIndex >= 0 else {
            return nil
        }
        
        return settingsViews[prevIndex]
    }
}
