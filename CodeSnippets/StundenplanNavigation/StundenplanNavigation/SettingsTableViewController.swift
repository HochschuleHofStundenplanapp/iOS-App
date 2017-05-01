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
    
    var selectedCoursesString = "..."
    var selectedSemesterString = "..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        saveChangesButton.setTitle(title, for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.tintColor = UIColor.hawBlue
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.hawBlue]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sectionChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UserData.sharedInstance.season = "SS"
        }else{
            UserData.sharedInstance.season = "WS"
        }
    }
    
    
    @IBAction func syncSwitchChanged(_ sender: UISwitch) {
        if(syncSwitch.isOn){
            UserData.sharedInstance.callenderSync = true
        } else {
            UserData.sharedInstance.callenderSync = false
        }
    }
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
        
        saveChangesButton.setTitle("0 Änderungen übernehmen", for: .normal)
        
    }
    
    func showAccessAlert() {
        let alert = UIAlertController(title: "Berechtigungen", message: "Es werden Berechtigungen benötigt um Einträge in den Kalender zu tätigen.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Schließen", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Einstellungen", style: .default, handler: { action in
             let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.open(openSettingsUrl!, options: [:], completionHandler: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        }
}
