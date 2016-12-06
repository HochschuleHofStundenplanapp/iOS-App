//
//  SettingsTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet var saveChangesButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var syncSwitch: UISwitch!

    @IBOutlet var courseTableViewCell: UITableViewCell!
    @IBOutlet var semesterTableViewCell: UITableViewCell!
    @IBOutlet var lecturesTableViewCell: UITableViewCell!

    @IBOutlet var selectedCoursesLabel: UILabel!
    @IBOutlet var selectedSemesterLabel: UILabel!
    @IBOutlet var selectedLecturesLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Settings.sharedInstance.copyData()
        //courseTableViewCell.isUserInteractionEnabled = false
        
        //selectedCoursesLabel.text = Setting.sharedInstance.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.tintColor = UIColor(red: 0.0039, green: 0.4078, blue: 0.6824, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 0.0039, green: 0.4078, blue: 0.6824, alpha: 1.0)]
        
//        Settings.sharedInstance.copyData()
        
        if Settings.sharedInstance.tmpSeason == .summer {
            segmentControl.selectedSegmentIndex = 0
        }else{
            segmentControl.selectedSegmentIndex = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sectionChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            Settings.sharedInstance.tmpSeason = .summer
        }else{
            Settings.sharedInstance.tmpSeason = .winter
        }
    }
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
        Settings.sharedInstance.commitChanges()
    }
}
