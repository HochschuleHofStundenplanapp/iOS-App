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
        switch indexPath.row {
        case 0:
            cell.oldNewDateLabel.text   = "Entfallener Termin"
            cell.dateLabel.text         = "09.11.2016"
            cell.timeLabel.text         = "14:00 Uhr"
            cell.roomLabel.text         = "FB001/002"
        default:
            cell.oldNewDateLabel.text   = "Ersatztermin"
            cell.dateLabel.text         = "09.11.2016"
            cell.timeLabel.text         = "14:00 Uhr"
            cell.roomLabel.text         = "TH001/002"
        }
        
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
