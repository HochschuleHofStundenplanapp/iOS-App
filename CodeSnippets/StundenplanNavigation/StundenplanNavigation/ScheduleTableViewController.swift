//
//  ScheduleTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {

    @IBOutlet var scheduleTableView: UITableView!
    var datasource : ScheduleTableViewDataSource!
    var delegate: ScheduleTableViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datasource = ScheduleTableViewDataSource()
        delegate = ScheduleTableViewDelegate()
        
        scheduleTableView.dataSource = datasource
        scheduleTableView.delegate = delegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.tintColor = UIColor(red: 0.9255, green: 0.3686, blue: 0.2902, alpha: 1.0)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 0.9255, green: 0.3686, blue: 0.2902, alpha: 1.0)]

        print("HIER")
//        print(Settings.sharedInstance.schedule.list.description)
//        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
