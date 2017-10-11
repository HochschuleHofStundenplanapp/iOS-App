//
//  LecturesTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 21.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class LecturesTableViewDataSource: NSObject, UITableViewDataSource {
    
    var tmpSelectedLectures: TmpSelectedLectures
    
    var lastSemester :  String = ""
    var myString : NSString = ""
    var lastColor: UIColor = UIColor(red: 0,green: 0,blue: 0, alpha: 0.2)
    
    
    init(tmpSelectedLectures: TmpSelectedLectures){
        self.tmpSelectedLectures = tmpSelectedLectures
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "LecturesCell")! as! LecturesTableViewCell
        
        let lecture = AllLectures().getElement(at: indexPath)
        
        
        
        
        if(lecture.semester.course.contraction != "Sprache"){
        myString  = "\(lecture.semester.course.contraction)\(lecture.semester.name) - \(lecture.name)" as NSString
        }else
        {
            myString = "\(lecture.semester.course.contraction) - \(lecture.name)" as NSString
  
        }
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String)
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: lastColor, range: NSRange(location:0,length:myString.length - lecture.name.characters.count - 2))
        
        //lecture.semester.course.contraction.characters.count + lecture.semester.name.characters.count
        cell.courseLabel.attributedText = myMutableString
        cell.docentLabel.text = lecture.lecturer
        cell.commentLabel.text = lecture.comment
        
        //NSDate Formatiert zu String
        var startTimeString = ""
        var endTimeString = ""
        
        let timeFormatter = DateFormatter()
        timeFormatter.locale = NSLocale(localeIdentifier: "de") as Locale!
        timeFormatter.dateFormat = "HH:mm"
        startTimeString = timeFormatter.string(from: lecture.startTime)
        endTimeString = timeFormatter.string(from: lecture.endTime)
        
        cell.timeLabel.text = startTimeString + " - " + endTimeString
        
        if tmpSelectedLectures.contains(lecture: lecture) {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllLectures().numberOfEntries(for: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.weekDays.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.weekDays[section]
    }
}
