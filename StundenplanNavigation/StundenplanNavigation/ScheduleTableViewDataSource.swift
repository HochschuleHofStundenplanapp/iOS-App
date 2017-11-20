//
//  ScheduleTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class ScheduleTableViewDataSource: NSObject, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if SelectedLectures().getOneDimensionalList().count > 0{
            return Constants.weekDays.count
        } else{
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if SelectedLectures().getOneDimensionalList().count > 0{
            return SelectedLectures().numberOfEntries(for: section)
        } else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        if SelectedLectures().getOneDimensionalList().count > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as! ScheduleTableViewCell
            
            let lecture = SelectedLectures().getElement(at: indexPath)
            
            let startTime = lecture.startTime
            let endTime = lecture.endTime
            
            var startTimeString = ""
            var endTimeString = ""
            
            let timeFormatter = DateFormatter()
            timeFormatter.locale = NSLocale(localeIdentifier: "de") as Locale!
            timeFormatter.dateFormat = "HH:mm"
            startTimeString = timeFormatter.string(from: startTime)
            endTimeString = timeFormatter.string(from: endTime)
            
            let rename = TaskLectureController()
            let lectureDate = Date()                                                // TODO: ✅🚨 auf Schnittstelle warten
            if rename.hasTask(for: lecture, at: lectureDate) {
                cell.hasTaskView.isHidden = false
                cell.hasTaskView.textColor = appColor.taskWarning
            } else {
                cell.hasTaskView.isHidden = true
            }
            
            cell.comment.text = lecture.comment
            cell.course.text = lecture.name
            cell.docent.text = lecture.lecturer
            cell.room.text = lecture.room
            cell.time.text = "\(startTimeString) - \(endTimeString)"
            
            return cell

        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCellEmpty") as! EmptyScheduleTableViewCell
            return cell
        }

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if SelectedLectures().getOneDimensionalList().count > 0{
            return Constants.weekDays[section]
        } else{
            return ""
        }
    }
}
