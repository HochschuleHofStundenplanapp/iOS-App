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
        lectureTableView.delegate = LecturesTableViewDelegate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
