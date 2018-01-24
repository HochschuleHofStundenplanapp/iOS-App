//
//  AppointmentTableViewController.swift
//  StundenplanNavigation
//
//  Created by Bastian Kusserow on 08.01.18.
//  Copyright © 2018 Hof University. All rights reserved.
//

import UIKit
import StundenplanFramework

class AppointmentTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let userData = UserData.sharedInstance
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    // MARK: - Table view data source
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return userData.appointments.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userData.appointments[section].appointments.count
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return userData.appointments[section].header
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentCell", for: indexPath)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        formatter.locale = NSLocale(localeIdentifier: "de") as Locale!
        let appointment = userData.appointments[indexPath.section].appointments[indexPath.row]
        cell.textLabel?.text = appointment.name
        cell.detailTextLabel?.text = "\(formatter.string(from: appointment.date.start)) \(appointment.date.start == appointment.date.end ? "" : "-" + formatter.string(from: appointment.date.end))"
        
        
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

