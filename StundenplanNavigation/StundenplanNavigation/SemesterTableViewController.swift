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
 
    var tmpSelectedCourses: TmpSelectedCourses!
    var tmpSelectedLectures: TmpSelectedLectures!
    var tmpSelectedSemesters: TmpSelectedSemesters!
    
    var semesterController: SemesterController!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor.white
        tabBarController?.tabBar.tintColor = UIColor.hawBlue

        semesterController = SemesterController(tmpSelectedLectures: tmpSelectedLectures, tmpSelectedSemesters: tmpSelectedSemesters)
        
        datasource = SemesterTableViewDataSource(tmpSelectedCourses: tmpSelectedCourses, tmpSelectedSemesters: tmpSelectedSemesters)
        delegate = SemesterTableViewDelegate(semesterController: semesterController)
        
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
