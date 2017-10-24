//
//  JsonChanges.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 18.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

class JsonChanges {
    fileprivate var pCL : [ChangedLecture]
    
   
    
    var changes : [ChangedLecture] {
        get {
            return pCL
        }
    }
    
    init? (data : Data)
    {
       
        
        pCL = [ChangedLecture]()
        let jsonT = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject
        guard let json = jsonT else {
            return nil
        }
        
        extractChanges(json)
    }
    
    fileprivate func extractChanges(_ json : AnyObject)
    {
        print("Extract Changes")
        
        guard let jsonData = JSONData.fromObject(json) else
        {
            return
        }
        guard let allResults = jsonData["changes"]?.array as [JSONData]! else
        {
            return
        }
        
        pCL = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "de_DE")
        timeFormatter.dateFormat = "HH:mm"
        
       
        
        for i in allResults
        {
            let newDay : String
            let newDate : String
            let newTime  : String
            let newRoom : String
            
            let splusname = (i["splusname"]?.string)!
            
           
            let id = (i["id"]?.string)!
            let name = (i["label"]?.string)!
            let docent = (i["docent"]?.string)!
            let comment = (i["comment"]?.string)!
            
            let group = (i["group"]?.string)!
            
            
            
            let oldDay = (i["original"]?["day"]?.string)!
            let oldDate = (i["original"]?["date"]?.string)!
            let oldTime = (i["original"]?["time"]?.string)!
            let oldRoom = (i["original"]?["room"]?.string)!
            if (i["alternative"] != nil) {
                
                newDay = (i["alternative"]?["day"]?.string)!
                newDate = (i["alternative"]?["date"]?.string)!
                newTime = (i["alternative"]?["time"]?.string)!
                newRoom = (i["alternative"]?["room"]?.string)!
            }
            else {
                newDay = ""
                newDate = ""
                newTime = ""
                newRoom = ""
            }
            
            let newId = Int(id)
            
            let newOldDate = dateFormatter.date(from: oldDate)
            let newNewDate = dateFormatter.date(from: newDate)
            
            let newOldTime = timeFormatter.date(from: oldTime)
            let newNewTime = timeFormatter.date(from: newTime)
            
            let reason = (i["reason"]?.string)!
            
            //newOldTime = newOldTime?.changeTimeDate(date: newOldTime!)
            //newNewTime = newNewTime?.changeTimeDate(date: newNewTime!)
            
            let newCL = ChangedLecture(id: newId!, name: name, docent: docent, comment: comment, oldTime: newOldTime!, oldDate: newOldDate!, oldDay: oldDay, oldRoom: oldRoom, newTime: newNewTime, newDate: newNewDate, newDay: newDay, newRoom: newRoom,  group: group, splusname: splusname, reason: reason)
            
            
          
            
               if(!UserData.sharedInstance.savedSplusnames.contains(splusname))
               {
                             UserData.sharedInstance.savedSplusnames.append(splusname)
                pCL.append(newCL)
                print ("füge element \(name) zu savedplusname hinzu")

                }
            
            
        }
    }
    
}
