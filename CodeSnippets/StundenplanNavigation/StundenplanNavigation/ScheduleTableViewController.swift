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
        tabBarController?.tabBar.tintColor = UIColor(red: 0.9255, green: 0.3686, blue: 0.2902, alpha: 1.0)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 0.9255, green: 0.3686, blue: 0.2902, alpha: 1.0)]

        //Überprüfe, ob Schedule leer ist. Falls ja, wird nur eine Section angezeigt.
        let countLectures = Settings.sharedInstance.savedSchedule.selectedLectures()
        datasource.scheduleIsEmpty = true
        for i in countLectures{
            if(i.count != 0){
                datasource.scheduleIsEmpty = false
            }
        }
        
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate.selectedIndexPath = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
