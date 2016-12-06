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
    
    let shared = Observer.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let season = Settings.sharedInstance.tmpSeason.rawValue
        
        datasource = CourseTableViewDataSource(tableView: self, ssws: season)
        delegate = CourseTableViewDelegate()
        
        tableView.dataSource = datasource
        tableView.delegate = delegate
        
        
    }
    
    func beginDownload(){
        print("begin download")
        //Show Activity Indicator
    }
    
    func endDownload(){
        print("end download")
        //Hide Activity Indicator
        
        courseTableView.reloadData()
    }
    
    func showNoInternetAlert(){
    
        //Hide Activity Indicator
        
        let alertController = UIAlertController(title: "Internetverbindung fehlgeschlagen", message:
            "Bitte verbinden Sie sich mit dem Internet", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            //Daten erneut laden
        } ))
        self.present(alertController, animated: true, completion: nil)
        
    }


    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.tintColor = UIColor(red: 0.0039, green: 0.4078, blue: 0.6824, alpha: 1.0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
