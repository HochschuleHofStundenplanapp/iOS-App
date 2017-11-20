//
//  ChangedLecture.swift
//  StundenplanNavigation
//
//  Created by Andreas Wolf on 18.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import Foundation

class ChangedLecture: NSObject, NSCoding {
    
    var id: Int
    var name: String
    var docent: String
    var comment: String
    var oldTime: Date
    var oldDate: Date
    var oldDay: String
    var oldRoom: String
    var newTime: Date?
    var newDate: Date?
    var newDay: String
    var newRoom: String
    var group: String
    var splusname : String
    var text : String?
    
    var idKey = "id"
    var nameKey = "name"
    var docentKey = "docent"
    var commentKey = "commentKey"
    var oldTimeKey = "oldTime"
    var oldDateKey = "oldDate"
    var oldDayKey = "oldDay"
    var oldRoomKey = "oldRoom"
    var newTimeKey = "newTime"
    var newDateKey = "newDate"
    var newDayKey = "newDay"
    var newRoomKey = "newRoom"
    var groupKey = "group"
    var splusnameKey = "splusname"
    var reasonkey = "reasonkey"
    
    //Studiengang einfügen
    
    init(id: Int, name: String, docent: String, comment: String,
         oldTime: Date, oldDate: Date, oldDay: String, oldRoom: String,
         newTime: Date?, newDate: Date?, newDay: String, newRoom: String,  group: String, splusname : String, reason : String?) {
        self.id = id
        self.name = name
        self.docent = docent
        self.comment = comment
        self.oldTime = oldTime
        self.oldDate = oldDate
        self.oldDay = oldDay
        self.oldRoom = oldRoom
        self.newTime = newTime
        self.newDate = newDate
        self.newDay = newDay
        self.newRoom = newRoom
        self.group = group
        self.splusname = splusname
        self.text = reason
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: idKey)
        name = aDecoder.decodeObject(forKey: nameKey) as! String
        docent = aDecoder.decodeObject(forKey: docentKey) as! String
        comment = aDecoder.decodeObject(forKey: commentKey) as! String
        oldTime = aDecoder.decodeObject(forKey: oldTimeKey) as! Date
        oldDate = aDecoder.decodeObject(forKey: oldDateKey) as! Date
        oldDay = aDecoder.decodeObject(forKey: oldDayKey) as! String
        oldRoom = aDecoder.decodeObject(forKey: oldRoomKey) as! String
        newTime = aDecoder.decodeObject(forKey: newTimeKey) as? Date
        newDate = aDecoder.decodeObject(forKey: newDateKey) as? Date
        newDay = aDecoder.decodeObject(forKey: newDayKey) as! String
        newRoom = aDecoder.decodeObject(forKey: newRoomKey) as! String
        group = aDecoder.decodeObject(forKey: groupKey) as! String
        splusname = aDecoder.decodeObject(forKey: splusnameKey) as! String
        
        if let reason = aDecoder.decodeObject(forKey: reasonkey) as? String{
            self.text = reason
        }else{
            self.text = ""
        }

        super.init()
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(id, forKey: idKey)
        aCoder.encode(name, forKey: nameKey)
        aCoder.encode(docent, forKey: docentKey)
        aCoder.encode(comment, forKey: commentKey)
        aCoder.encode(oldTime, forKey: oldTimeKey)
        aCoder.encode(oldDate, forKey: oldDateKey)
        aCoder.encode(oldDay, forKey: oldDayKey)
        aCoder.encode(oldRoom, forKey: oldRoomKey)
        aCoder.encode(newTime, forKey: newTimeKey)
        aCoder.encode(newDate, forKey: newDateKey)
        aCoder.encode(newDay, forKey: newDayKey)
        aCoder.encode(newRoom, forKey: newRoomKey)
        aCoder.encode(group, forKey: groupKey)
        aCoder.encode(splusname, forKey: splusnameKey)
        aCoder.encode(text, forKey: reasonkey)
    }
    
    var combinedOldDate: Date {
        get {
            let calendar = Calendar.current
            
            let day = calendar.component(.day, from: oldDate)
            let month = calendar.component(.month, from: oldDate)
            let year = calendar.component(.year, from: oldDate)
            
            let hour = calendar.component(.hour, from: oldTime)
            let minutes = calendar.component(.minute, from: oldTime)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yy HH:mm"
            dateFormatter.locale = Locale(identifier: "de_DE")
            
            let end = dateFormatter.date(from:"\(day).\(month).\(year) \(hour):\(minutes)")
            
            return end!
        }
    }
    
    var combinedNewDate: Date! {
        get {
            let calendar = Calendar.current
            var end : Date? = nil
            
            if (newDate != nil) {
                let day = calendar.component(.day, from: newDate!)
                let month = calendar.component(.month, from: newDate!)
                let year = calendar.component(.year, from: newDate!)
                
                let hour = calendar.component(.hour, from: newTime!)
                let minutes = calendar.component(.minute, from: newTime!)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yy HH:mm"
                dateFormatter.locale = Locale(identifier: "de_DE")
                
                end = dateFormatter.date(from:"\(day).\(month).\(year) \(hour):\(minutes)")! as Date?
            }
            
            return end
        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return self == object as! ChangedLecture
    }
    
 
    
    static func == (lhs: ChangedLecture, rhs: ChangedLecture) -> Bool {

        return (lhs.id == rhs.id)
    }
}
