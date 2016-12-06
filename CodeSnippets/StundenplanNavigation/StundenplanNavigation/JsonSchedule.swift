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
    private var course : String!
    
    var schedule : [Lecture]? {
        get {
            return pSchedule
        }
    }
    
    init? (data : Data, course: String)
    {
        super.init()
        self.course = course
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
            
            let newId = Int(id)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let newStartDate = dateFormatter.date(from: startd)
            let newEndDate = dateFormatter.date(from: endd)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let newStartTime = timeFormatter.date(from: startt)
            let newEndTime = timeFormatter.date(from: endt)
            
            
            
            let newLecture = Lecture(id: newId!, name: name, lecture: docent, type: type, group: group, starttime:newStartTime!, endTime: newEndTime!, startdate: newStartDate!, enddate: newEndDate!, day: day, room: room, course: course, comment: comment)
            pSchedule?.append(newLecture)
        }
    }
}
