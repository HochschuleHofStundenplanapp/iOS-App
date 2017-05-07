//
//  SemesterTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class SemesterTableViewController: UITableViewController {

    @IBOutlet var semesterTableView: UITableView!
    var datasource : SemesterTableViewDataSource!
    var delegate: SemesterTableViewDelegate!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor.white
        tabBarController?.tabBar.tintColor = UIColor.hawBlue

        datasource = SemesterTableViewDataSource()
        delegate = SemesterTableViewDelegate()
        
        tableView.dataSource = datasource
        tableView.delegate = delegate
        
        //Entfernt Seperators von leeren Cells am Ende der Tabelle
        tableView.tableFooterView = UIView(frame: .zero)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
