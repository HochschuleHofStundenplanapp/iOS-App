//
//  ScheduleTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class ScheduleTableViewDataSource: NSObject, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let lectures = Settings.sharedInstance.schedule.selectedLectures()
        
        return lectures[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell2") as! ScheduleTableViewCell
        cell.clipsToBounds = true
        
        let schedule = Settings.sharedInstance.schedule.selectedLectures()    

        let startDate = schedule[indexPath.section][indexPath.row].startdate
        let startTime = schedule[indexPath.section][indexPath.row].starttime
        let endTime = schedule[indexPath.section][indexPath.row].endTime
        
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
        cell.type.text = schedule[indexPath.section][indexPath.row].type
        cell.course.text = schedule[indexPath.section][indexPath.row].name
        cell.time.text = startTimeString + " - " + endTimeString
        cell.docent.text = schedule[indexPath.section][indexPath.row].lecture
        cell.room.text = schedule[indexPath.section][indexPath.row].room
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.weekDays.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.weekDays[section]
    }
}
