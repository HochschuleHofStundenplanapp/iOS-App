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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        
        datasource = CourseTableViewDataSource()
        delegate = CourseTableViewDelegate()
        
        tableView.dataSource = datasource
        tableView.delegate = delegate
        
        
    }
    
    func beginDownload(){
        //Show Activity Indicator
    }
    
    func endDownload(){
        //Hide Activity Indicator
        
        courseTableView.reloadData()
    }
    
    func showNoInternetAlert(){
    
        //Hide Activity Indicator
        
        _ = navigationController?.popViewController(animated: true)
        
        let alertController = UIAlertController(title: "Internetverbindung fehlgeschlagen", message:
            "Bitte verbinden Sie sich mit dem Internet", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            //Daten erneut laden
        } ))
        self.present(alertController, animated: true, completion: nil)
        
    }


    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.tintColor = UIColor.hawRed
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
