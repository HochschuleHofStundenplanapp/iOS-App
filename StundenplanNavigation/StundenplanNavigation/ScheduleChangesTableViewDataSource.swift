//
//  ScheduleChangesTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit
import StundenplanFramework
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
        
        if(UserData.sharedInstance.oldChanges.count == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleChangesCellEmpty") as! EmptyScheduleChangesTableViewCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleChangesCell") as! ScheduleChangesTableViewCell
            
            //Inhalt der Rows // Beispieldaten!
            
            let changedLectures = UserData.sharedInstance.oldChanges
            
            let reason = changedLectures[indexPath.section].text
            //print("Reason: \(reason)")
            if(changedLectures.count != 0){
                
                cell.oldDateLabel.text         = dateFormatter.string(from: changedLectures[indexPath.section].oldDate)
                cell.oldTimeLabel.text         = timeFormatter.string(from: changedLectures[indexPath.section].oldTime)
                cell.oldRoomLabel.text         = changedLectures[indexPath.section].oldRoom
                cell.newDateLabel.text         = reason
                
                if (changedLectures[indexPath.section].newDate != nil)
                {
                    cell.newDateLabel.text = dateFormatter.string(from: changedLectures[indexPath.section].newDate!)
                    cell.newTimeLabel.text = timeFormatter.string(from: changedLectures[indexPath.section].newTime!)
                    cell.newRoomLabel.text = changedLectures[indexPath.section].newRoom
                    
                }
                else {
                    cell.newDateLabel.text = ""
                    cell.newTimeLabel.text = ""
                    cell.newRoomLabel.text = ""
                }
                
                if let info = reason {
                    
                    cell.additionalInfo.text = "⚠︎ \(info)"
                    cell.additionalInfo.isHidden = info.isEmpty
                    cell.heightConstraint.priority = info.isEmpty ? UILayoutPriority(rawValue: 999) : UILayoutPriority(rawValue: 250)
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
          return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfChanges = UserData.sharedInstance.oldChanges.count
        //wenn 0 zurueckgegeben wird, erfolgt keine Aktualisierung der table view und keine Anzeige, dass keine Aenderungen vorliegen
        //daher Rueckgabe von 1
        if(numberOfChanges == 0) {
            return 1
        } else{
            return numberOfChanges
        }
//        return UserData.sharedInstance.oldChanges.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(UserData.sharedInstance.oldChanges.count == 0){
            return ""
        }
        let changedLectures = UserData.sharedInstance.oldChanges
        if(changedLectures.count != 0){
            return changedLectures[section].name
        } else {
            
            return ""
        }
    }
    
    
}
