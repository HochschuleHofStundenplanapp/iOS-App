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
    
    var changesAreEmpty = true
    
    
    override init() {
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
    }
    
    func reloadData(){
        networkController = NetworkController()
        networkController.loadChanges()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(changesAreEmpty){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleChangesCellEmpty") as! EmptyScheduleChangesTableViewCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleChangesCell") as! ScheduleChangesTableViewCell
            
            //Inhalt der Rows // Beispieldaten!
            
            let changedLectures = Settings.sharedInstance.savedChanges.changes
            
            
            if(changedLectures.count != 0){
                
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
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(changesAreEmpty){
            return 1
        }
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(changesAreEmpty){
            return 1
        }
        // #warning Incomplete implementation, return the number of sections
        return Settings.sharedInstance.savedChanges.changes.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(changesAreEmpty){
            return ""
        }
        let changedLectures = Settings.sharedInstance.savedChanges.changes
        if(changedLectures.count != 0){
            return changedLectures[section].name
        } else {
            
            return ""
        }
    }
    
}
