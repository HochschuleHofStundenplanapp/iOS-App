//
//  SettingsTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var syncSwitch: UISwitch!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.tintColor = UIColor(red: 0.0039, green: 0.4078, blue: 0.6824, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 0.0039, green: 0.4078, blue: 0.6824, alpha: 1.0)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  (segue.identifier == "SettingsToCourses") {
//            let controller = segue.destination as? CourseTableViewController
            
            if segmentControl.selectedSegmentIndex == 0 {
                Settings.sharedInstance.season = .summer
            }else{
                Settings.sharedInstance.season = .winter
            }
            
        }
    }
}
