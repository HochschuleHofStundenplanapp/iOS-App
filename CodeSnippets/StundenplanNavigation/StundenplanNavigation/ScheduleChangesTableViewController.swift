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
        
        datasource = ScheduleChangesTableViewDataSource()
        delegate = ScheduleChangesTableViewDelegate()
        
        scheduleChangesTableView.dataSource = datasource
        scheduleChangesTableView.delegate = delegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.tintColor = UIColor(red: 0.9843, green: 0.7294, blue: 0, alpha: 1.0)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 0.9843, green: 0.7294, blue: 0, alpha: 1.0)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
