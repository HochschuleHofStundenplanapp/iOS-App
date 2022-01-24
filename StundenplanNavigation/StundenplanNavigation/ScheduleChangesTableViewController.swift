//
//  ScheduleChangesTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit
import StundenplanFramework
class ScheduleChangesTableViewController: UITableViewController, myObserverProtocol {

    @IBOutlet var scheduleChangesTableView: UITableView!
    
    var datasource : ScheduleChangesTableViewDataSource!
    var delegate: ScheduleChangesTableViewDelegate!
    let usrdata : UserData! = UserData.sharedInstance
    
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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        setupObserver()
        
        if #available(iOS 11.0, *) {
            setUpNavbar()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setUpUI() {
        switch UserData.sharedInstance.getSelectedAppColor() {
        case Faculty.economics.faculty:
            appColor.faculty = Faculty.economics
        case Faculty.computerScience.faculty:
            appColor.faculty = Faculty.computerScience
        case Faculty.engineeringSciences.faculty:
            appColor.faculty = Faculty.engineeringSciences
        default:
            //print("selected appcolor was: " + UserData.sharedInstance.getSelectedAppColor())
            appColor.faculty = Faculty.default
        }
        
        //print("loaded Color", appColor.faculty)

        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = appColor.tintColor
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            // Fallback on earlier versions
            UINavigationBar.appearance().barTintColor = appColor.tintColor
            tabBarController?.tabBar.tintColor = appColor.tintColor
            navigationController?.navigationBar.tintColor = appColor.tintColor
        }

    }
    
    @available(iOS 11.0, *)
    func setUpNavbar(){
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @inline(__always)
    fileprivate func setupObserver(){
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(alertSererUnreachable), name: Notification.Name("ServerUnreachable"), object: nil)
    }
    
    func update(s: String?) {
        //print ( "Lade Daten für Changes neu (tableview update)")
        self.scheduleChangesTableView.reloadData()
        
        // Änderungen mit dem Kalender synchronisieren
        //dump(UserData.sharedInstance.calenderSync)
        if UserData.sharedInstance.calenderSync {
            CalendarController().updateAllEvents(changes: AllChanges().getChangedLectures())
        }
    }

    @objc func handleRefresh(refreshControl: UIRefreshControl) {
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
        scheduleChangesController.handleAllChanges()
        
        //Entfernen des Badges
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        setUpUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func alertSererUnreachable(){
        let alert = UIAlertController(title: "Netzwerkfehler", message: "Server zurzeit nicht erreichbar. Versuchen sie es zu einen späteren Zeitpunkt nochmal", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        present(alert, animated: true) {() -> Void in }
    }
}
