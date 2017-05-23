//
//  ScheduleChangesTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class ScheduleChangesTableViewController: UITableViewController, myObserverProtocol {

    @IBOutlet var scheduleChangesTableView: UITableView!
    
    var datasource : ScheduleChangesTableViewDataSource!
    var delegate: ScheduleChangesTableViewDelegate!
    
            var scheduleChangesController : ScheduleChangesController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleChangesController = ScheduleChangesController()
        scheduleChangesController.addNewObserver(o: self)
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        
        datasource = ScheduleChangesTableViewDataSource()
        delegate = ScheduleChangesTableViewDelegate()
        
        scheduleChangesTableView.dataSource = datasource
        scheduleChangesTableView.delegate = delegate
        
        //Entfernt Seperators von leeren Cells am Ende der Tabelle
        tableView.tableFooterView = UIView(frame: .zero)
        

    
    }
    
    func update(s: String?) {
        print ( "Lade Daten für Changes neu (tableview update)")
        self.scheduleChangesTableView.reloadData()
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        self.refreshControl?.endRefreshing()
    }
    
    func showNoInternetAlert(){
        
        let alertController = UIAlertController(title: "Internetverbindung fehlgeschlagen", message:
            "Bitte verbinden Sie sich mit dem Internet", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            //Daten erneut laden
        } ))
        self.present(alertController, animated: true, completion: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        scheduleChangesController.cancelAllNetworkJobs()
           }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.tintColor = UIColor.hawYellow
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.hawYellow]
        
        
       // scheduleChangesController.handleChanges()
        scheduleChangesController.handleAllChanges()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
