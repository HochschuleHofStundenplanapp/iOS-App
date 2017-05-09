//
//  JsonLectures.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 09.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

//!!!!!!!!!!!!!Semestera anpassen!!!!!!!!!!!!!!!!!!

import UIKit

class JsonLectures: NSObject {
    fileprivate var pLectures : [Lecture]?
    fileprivate var semester: Semester!
    
    var lectures : [Lecture]? {
        get {
            return pLectures
        }
    }
    
    init? (data : Data, semester: Semester)
    {
        super.init()
        self.semester = semester
        let jsonT = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject
        guard let json = jsonT else {
            return nil
        }
        
        extractLectures(json)
    }
    
    fileprivate func extractLectures(_ json : AnyObject)
    {
        guard let jsonData = JSONData.fromObject(json), let allResults = jsonData["schedule"]?.array as [JSONData]! else
        {
            return
        }
        
        pLectures = []
        
        for i in allResults
        {
            let id = (i["id"]?.string)!
            let splusname = (i["splusname"]?.string)!
            let name = (i["label"]?.string)!
            let docent = (i["docent"]?.string)!
            let type = (i["type"]?.string)!
            let style = (i["style"]?.string)!
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
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            dateFormatter.locale = Locale(identifier: "de_DE")
            
            var newStartDate = dateFormatter.date(from: startd + " " + startt)
            var newEndDate = dateFormatter.date(from: endd  + " " + endt)
            
            let season = UserData.sharedInstance.selectedSeason
            newStartDate = newStartDate?.startLecture(startDate: newStartDate!,weekdayString: day, semester: season)
            newEndDate = newEndDate?.endLecture(endDate: newEndDate!, weekdayString: day, semester: season)
            
            let iteration = 7

            let lecture = Lecture(id: newId!, splusname: splusname, name: name, lecturer: docent, type: type, style: style, group: group, startdate: newStartDate!, enddate: newEndDate!, day: day, room: room, semester: self.semester, comment: comment, iteration: iteration)
          
            pLectures?.append(lecture)
        }
    }
}
