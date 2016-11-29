//
//  LecturesTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class LecturesTableViewController: UITableViewController {

    @IBOutlet var lectureTableView: UITableView!
    var dataSource : LecturesTableViewDataSource!
    var delegate: LecturesTableViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor.white
        
        dataSource = LecturesTableViewDataSource(tableView: self.tableView)
        lectureTableView.dataSource = dataSource
        
        delegate = LecturesTableViewDelegate()
        lectureTableView.delegate = delegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.tintColor = UIColor(red: 0.0039, green: 0.4078, blue: 0.6824, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
