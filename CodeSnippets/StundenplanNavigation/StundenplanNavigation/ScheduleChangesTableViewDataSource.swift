//
//  ScheduleChangesTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class ScheduleChangesTableViewDataSource: NSObject, UITableViewDataSource {
    
    var networkController : NetworkController!
    var lectureSections = [String]()
    var dateFormatter : DateFormatter
    var timeFormatter : DateFormatter
    
    
    init(tableView: ScheduleChangesTableViewController) {
        print("ScheduleChangesTableViewDataSource init called")
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        
    }
    
    func reloadData(tableView : ScheduleChangesTableViewController){
        networkController = NetworkController()
        networkController.loadChanges(tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleChangesCell") as! ScheduleChangesTableViewCell
        
        //Inhalt der Rows // Beispieldaten!
        
        let changedLectures = Settings.sharedInstance.savedChanges.changes
        
        cell.oldDateLabel.text         = dateFormatter.string(from: changedLectures[indexPath.section].oldDate)
        cell.oldTimeLabel.text         = timeFormatter.string(from: changedLectures[indexPath.section].oldTime)
        cell.oldRoomLabel.text         = changedLectures[indexPath.section].oldRoom
        
        if (changedLectures[indexPath.section].newDate != nil)
        {
            cell.newDateLabel.text = dateFormatter.string(from: changedLectures[indexPath.section].newDate!)
            cell.newTimeLabel.text = timeFormatter.string(from: changedLectures[indexPath.section].newTime!)
            cell.newRoomLabel.text = changedLectures[indexPath.section].newRoom
        }
        else {
            cell.newDateLabel.text = "Entfällt"
            cell.newTimeLabel.text = "wegen"
            cell.newRoomLabel.text = "Erkrankung"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return Settings.sharedInstance.savedChanges.changes.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let changedLectures = Settings.sharedInstance.savedChanges.changes
        return changedLectures[section].name
    }

}
