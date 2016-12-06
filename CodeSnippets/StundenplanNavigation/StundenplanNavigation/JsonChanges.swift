//
//  JsonChanges.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 18.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

class JsonChanges {
    fileprivate var pCL : [ChangedLecture]?
    
    var changes : [ChangedLecture]? {
        get {
            return pCL
        }
    }
    
    init? (data : Data)
    {
        let jsonT = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject
        guard let json = jsonT else {
            return nil
        }
        
        extractChanges(json)
    }
    
    fileprivate func extractChanges(_ json : AnyObject)
    {
        guard let jsonData = JSONData.fromObject(json) else
        {
            return
        }
        guard let allResults = jsonData["changes"]?.array as [JSONData]! else
        {
            return
        }
        
        pCL = []
        
        for i in allResults
        {
            let id = (i["id"]?.string)!
            let name = (i["label"]?.string)!
            let docent = (i["docent"]?.string)!
            let comment = (i["comment"]?.string)!
            let oldDay = (i["original"]?["day"]?.string)!
            let oldDate = (i["original"]?["date"]?.string)!
            let oldTime = (i["original"]?["time"]?.string)!
            let oldRoom = (i["original"]?["room"]?.string)!
            let newDay = (i["alternative"]?["day"]?.string)!
            let newDate = (i["alternative"]?["date"]?.string)!
            let newTime = (i["alternative"]?["time"]?.string)!
            let newRoom = (i["alternative"]?["room"]?.string)!
            
            let newId = Int(id)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let newOldDate = dateFormatter.date(from: oldDate)
            let newNewDate = dateFormatter.date(from: newDate)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let newOldTime = timeFormatter.date(from: oldTime)
            let newNewTime = timeFormatter.date(from: newTime)
            
            
            
            let newCL = ChangedLecture(id: newId!, name: name, docent: docent, comment: comment, oldTime: newOldTime!, oldDate: newOldDate!, oldDay: oldDay, oldRoom: oldRoom, newTime: newNewTime!, newDate: newNewDate!, newDay: newDay, newRoom: newRoom)
            pCL?.append(newCL)
        }
    }
    
}
