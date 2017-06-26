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
        
        //Entfernt Seperators von leeren Cells am Ende der Tabelle
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        tabBarController?.tabBar.tintColor = UIColor(red: 201/255, green: 55/255, blue: 59/255, alpha: 1)
//        tabBarController?.tabBar.tintColor = UIColor.white

        
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.hawRed]

    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
