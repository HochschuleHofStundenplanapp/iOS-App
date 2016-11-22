//
//  ScheduleChangesTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class ScheduleChangesTableViewDataSource: NSObject, UITableViewDataSource {
    
    //Beispieldaten
    let weekdaysSections = ["Sport und Gesundheit", "Tablet Computing 1"]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleChangesCell") as! ScheduleChangesTableViewCell
        
        //Inhalt der Rows // Beispieldaten!

        cell.oldDateLabel.text         = "09.11.2016"
        cell.oldTimeLabel.text         = "14:00 Uhr"
        cell.oldRoomLabel.text         = "FB001/002"

        cell.newDateLabel.text         = "09.11.2016"
        cell.newTimeLabel.text         = "14:00 Uhr"
        cell.newRoomLabel.text         = "TH001/002"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.weekdaysSections[section]
    }
}
