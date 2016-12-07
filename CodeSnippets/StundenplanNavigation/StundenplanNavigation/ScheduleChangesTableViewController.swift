//
//  ScheduleChangesTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class ScheduleChangesTableViewController: UITableViewController {

    @IBOutlet var scheduleChangesTableView: UITableView!
    
    var datasource : ScheduleChangesTableViewDataSource!
    var delegate: ScheduleChangesTableViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datasource = ScheduleChangesTableViewDataSource(tableView: self)
        delegate = ScheduleChangesTableViewDelegate()
        
        scheduleChangesTableView.dataSource = datasource
        scheduleChangesTableView.delegate = delegate
    }
    
    func beginDownload(){
        print("begin download")
        //Show Activity Indicator
    }
    
    func endDownload(){
        print("end download")
        
        print("\(Settings.sharedInstance.savedChanges.changes.count) Stundenplanänderungen geladen")
        Settings.sharedInstance.savedChanges.sort()
        //Hide Activity Indicator
        
        tableView.reloadData()
    }
    
    func showNoInternetAlert(){
        
        //Hide Activity Indicator
        
        let alertController = UIAlertController(title: "Internetverbindung fehlgeschlagen", message:
            "Bitte verbinden Sie sich mit dem Internet", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            //Daten erneut laden
        } ))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.tintColor = UIColor(red: 0.9843, green: 0.7294, blue: 0, alpha: 1.0)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 0.9843, green: 0.7294, blue: 0, alpha: 1.0)]
        
        self.datasource.reloadData(tableView: self)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
