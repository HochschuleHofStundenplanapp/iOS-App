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
        
        SelectedLectures().sortLecturesForSchedule()
        tableView.reloadData()
        
        tabBarController?.tabBar.tintColor = UIColor(red: 201/255, green: 55/255, blue: 59/255, alpha: 1)
    }
}
