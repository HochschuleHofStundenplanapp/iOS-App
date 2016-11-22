//
//  ScheduleTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class ScheduleTableViewDataSource: NSObject, UITableViewDataSource{

    let weekdays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        var weekdaysSections = [("Montag", 0), ("Dienstag",0), ("Mittwoch",0), ("Donnerstag",0), ("Freitag",0), ("Samstag",0)]
        var rowsInSections : [[Lecture]]
        let schedule = Settings.sharedInstance.schedule.list    //Hier noch selectedLectures() verwenden!!
        
        
        for lec in schedule{
        var i = 0
            for day in weekdaysSections{
                
                if lec.day == day.0{
                    
                    weekdaysSections[i].1 = weekdaysSections[i].1 + 1
<<<<<<< Updated upstream
//                    print("BIN DRIN")
=======
                    print("BIN DRIN")
                    rowsInSections[i].append(lec)
>>>>>>> Stashed changes
                }
                i = i+1
            }
        }
        
//        print(weekdaysSections.description)
        
        return weekdaysSections[section].1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell2") as! ScheduleTableViewCell
        cell.clipsToBounds = true
        
        let schedule = Settings.sharedInstance.schedule.list    //Hier noch selectedLectures() verwenden!!

        let startDate = schedule[indexPath.row].startdate
        let startTime = schedule[indexPath.row].starttime
        let endTime = schedule[indexPath.row].endTime
        
        var startDateString = ""
        var startTimeString = ""
        var endTimeString = ""
        
        let timeFormatter = DateFormatter()
        timeFormatter.locale = NSLocale(localeIdentifier: "de") as Locale!
        timeFormatter.dateFormat = "HH:mm"
        startTimeString = timeFormatter.string(from: startTime)
        endTimeString = timeFormatter.string(from: endTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "de") as Locale!
        dateFormatter.dateFormat = "dd.MM.yy"
        startDateString = dateFormatter.string(from: startDate)
        
        cell.startDate.text = startDateString
        cell.type.text = schedule[indexPath.row].type
        cell.course.text = schedule[indexPath.row].name
        cell.time.text = startTimeString + " - " + endTimeString
        cell.docent.text = schedule[indexPath.row].docent
        cell.room.text = schedule[indexPath.row].room
        
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.weekdays[section]
    }
}
