//
//  LecturesTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 21.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class LecturesTableViewDataSource: NSObject, UITableViewDataSource {

    var networkController : NetworkController
    
    init(tableView : UITableView) {
        networkController = NetworkController()
        networkController.loadSchedule(tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "LecturesCell")! as! LecturesTableViewCell
        
        let lecture = Settings.sharedInstance.tmpSchedule.getLectureAt(section: indexPath.section, row: indexPath.row)
        
        
        cell.courseLabel.text = lecture.name
        cell.docentLabel.text = lecture.lecturer
        cell.commentLabel.text = lecture.comment
        
        //NSDate Formatiert zu String
        var startTimeString = ""
        var endTimeString = ""
        
        let timeFormatter = DateFormatter()
        timeFormatter.locale = NSLocale(localeIdentifier: "de") as Locale!
        timeFormatter.dateFormat = "HH:mm"
        startTimeString = timeFormatter.string(from: lecture.starttime)
        endTimeString = timeFormatter.string(from: lecture.endTime)
        
        cell.timeLabel.text = startTimeString + " - " + endTimeString
        
        if(Settings.sharedInstance.tmpSchedule.isSelected(section: indexPath.section, row: indexPath.row)){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.sharedInstance.tmpSchedule.sizeAt(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.weekDays.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.weekDays[section]
    }
}
