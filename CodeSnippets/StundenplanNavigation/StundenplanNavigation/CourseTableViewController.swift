//
//  CourseTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class CourseTableViewController: UITableViewController {

    @IBOutlet var courseTableView: UITableView!
    var datasource : CourseTableViewDataSource!
    var delegate: CourseTableViewDelegate!
    var selectedSSWS : String!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        
        datasource = CourseTableViewDataSource(tableView: courseTableView, ssws: selectedSSWS)
        delegate = CourseTableViewDelegate()
        
        tableView.dataSource = datasource
        tableView.delegate = delegate
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
