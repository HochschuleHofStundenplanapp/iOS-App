//
//  ScheduleChangesTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class ScheduleChangesTableViewController: UITableViewController {

    @IBOutlet var scheduleChangesTableView: UITableView!
    
    var datasource : ScheduleChangesTableViewDataSource!
    var delegate: ScheduleChangesTableViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        
        datasource = ScheduleChangesTableViewDataSource(tableView: self)
        delegate = ScheduleChangesTableViewDelegate()
        
        scheduleChangesTableView.dataSource = datasource
        scheduleChangesTableView.delegate = delegate
        
        //Entfernt Seperators von leeren Cells am Ende der Tabelle
        tableView.tableFooterView = UIView(frame: .zero)
    
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        datasource.reloadData(tableView: self)
        self.tableView.reloadData()
    }
    
    func beginDownload(){
        //Show Activity Indicator
    }
    
    func endDownload(){
        Settings.sharedInstance.savedChanges.sort()
        //dump(Settings.sharedInstance.savedChanges.sort())
        
        if Settings.sharedInstance.savedCalSync {
        // Noch nicht getestet - Berechtigungen nicht berücksichtigt 
            if(CalendarInterface().checkCalendarAuthorizationStatus()) {
                dump(Settings.sharedInstance.savedChanges)
                CalendarInterface().updateAllEvents(changes: Settings.sharedInstance.savedChanges)
                
            }
        }
        
        //Überprüfe, ob Changes vorhanden sind. Falls nein, wird nur eine Section angezeigt.
        if(Settings.sharedInstance.savedChanges.changes.count == 0){
            datasource.changesAreEmpty = true
        }
        else{
            datasource.changesAreEmpty = false
        }
        
        //Hide Activity Indicator
        refreshControl?.endRefreshing()
        tableView.reloadData()
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
        
        tabBarController?.tabBar.tintColor = Constants.HAWYellow
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.HAWYellow]
        self.datasource.reloadData(tableView: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
