//
//  ScheduleChangesTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class ScheduleChangesTableViewDataSource: NSObject, UITableViewDataSource {
    
    
    
    var dateFormatter : DateFormatter
    var timeFormatter : DateFormatter
   
   override init() {
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(ServerData.sharedInstance.allChanges.count == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleChangesCellEmpty") as! EmptyScheduleChangesTableViewCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleChangesCell") as! ScheduleChangesTableViewCell
            
            //Inhalt der Rows // Beispieldaten!
            
            let changedLectures = ServerData.sharedInstance.allChanges
            
            
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
        
          return ServerData.sharedInstance.allChanges.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return ServerData.sharedInstance.allChanges.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(ServerData.sharedInstance.allChanges.count == 0){
            return ""
        }
        let changedLectures = ServerData.sharedInstance.allChanges
        if(changedLectures.count != 0){
            return changedLectures[section].name
        } else {
            
            return ""
        }
    }
    
    
}
