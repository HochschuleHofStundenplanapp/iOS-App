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
    var lastLectureGroup : (courseInfo : String, semInfo : String)
    var hightLightLine : Bool
    
    init(tableView : LecturesTableViewController) {
        networkController = NetworkController()
        networkController.loadSchedule(tableView: tableView)
        lastLectureGroup.courseInfo = ""
        lastLectureGroup.semInfo = ""
        hightLightLine = false
    }
    
    private func computeIndexedBackgroundColor (currentPosition : IndexPath) -> UIColor
    {
        var lastCourse = Settings.sharedInstance.tmpSchedule.getLectureAt(section: 0, row: 0).course.nameDe
        var lastSemester = Settings.sharedInstance.tmpSchedule.getLectureAt(section: 0, row: 0).semester.name
        var hightLighted = false
        
        for i in 0..<currentPosition.section
        {
            for  j in 0..<Settings.sharedInstance.tmpSchedule.sizeAt(section: i)
            {
                let lecture = Settings.sharedInstance.tmpSchedule.getLectureAt(section: i, row: j)
                let course = lecture.course.nameDe
                let semester = lecture.semester.name
        
                if course != lastCourse || semester != lastSemester
                {
                    hightLighted = !hightLighted
                    lastCourse = course
                    lastSemester = semester
                }
            }
        }

        let section = currentPosition.section
        for j in 0...currentPosition.row
        {
            let lecture = Settings.sharedInstance.tmpSchedule.getLectureAt(section: section, row: j)
            let course = lecture.course.nameDe
            let semester = lecture.semester.name
            
            if course != lastCourse || semester != lastSemester
            {
                hightLighted = !hightLighted
                lastCourse = course
                lastSemester = semester
            }
        }
        
        if hightLighted
        {
            return UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1.0)
        }
        return UIColor.white   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "LecturesCell")! as! LecturesTableViewCell
        
        let lecture = Settings.sharedInstance.tmpSchedule.getLectureAt(section: indexPath.section, row: indexPath.row)
        let cellColor = computeIndexedBackgroundColor(currentPosition : indexPath)
        
        cell.backgroundColor = cellColor
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
