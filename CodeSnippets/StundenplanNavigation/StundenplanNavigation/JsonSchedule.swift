//
//  JsonSchedule.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 18.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import UIKit

class JsonSchedule: NSObject {
    fileprivate var pSchedule : [Lecture]?
    private var course : Course!
    private var semester : Semester!
    
    var schedule : [Lecture]? {
        get {
            return pSchedule
        }
    }
    
    init? (data : Data, course: Course, semester: Semester)
    {
        super.init()
        self.course = course
        self.semester = semester
        let jsonT = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject
        guard let json = jsonT else {
            return nil
        }
        
        extractSchedule(json)
    }
    
    fileprivate func extractSchedule(_ json : AnyObject)
    {
        guard let jsonData = JSONData.fromObject(json) else
        {
            return
        }
        guard let allResults = jsonData["schedule"]?.array as [JSONData]! else
        {
            return
        }
        
        pSchedule = []
        
        for i in allResults
        {
            let id = (i["id"]?.string)!
            let name = (i["label"]?.string)!
            let docent = (i["docent"]?.string)!
            let type = (i["type"]?.string)!
            let group = (i["group"]?.string)!
            let startt = (i["starttime"]?.string)!
            let endt = (i["endtime"]?.string)!
            let startd = (i["startdate"]?.string)!
            let endd = (i["enddate"]?.string)!
            let day = (i["day"]?.string)!
            let room = (i["room"]?.string)!
            let comment = (i["comment"]?.string)!
            let eventIDs = [String]()
            
            let newId = Int(id)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            var newStartDate = dateFormatter.date(from: startd)
            var newEndDate = dateFormatter.date(from: endd)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            var newStartTime = timeFormatter.date(from: startt)
            var newEndTime = timeFormatter.date(from: endt)
            
            let ssws = Settings.sharedInstance.tmpSeason.rawValue
            
            newStartDate = newStartDate?.startLecture(weekdayString: day, semester: ssws)
            newEndDate = newEndDate?.endLecture(weekdayString: day, semester: ssws)
            newStartTime = newStartTime?.changeTimeDate(date: newStartTime!)
            newEndTime = newEndTime?.changeTimeDate(date: newEndTime!)
            

            let newLecture = Lecture(id: newId!, name: name, lecture: docent, type: type, group: group, starttime:newStartTime!, endTime: newEndTime!, startdate: newStartDate!, enddate: newEndDate!, day: day, room: room, course: course,semester:semester, comment: comment, eventIDs: eventIDs)
            pSchedule?.append(newLecture)
        }
    }
}
