//
//  Lecture.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 18.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

//Vorlesung
class Lecture : NSObject, NSCopying, NSCoding {
    
    var id: Int
    var name: String
    var lecturer: String
    var type: String
    var group: String
    var starttime: Date
    var endTime: Date
    var startdate: Date
    var enddate: Date
    var day: String
    var room: String
    var selected: Bool
    var course: String
    var comment : String
    var eventIDs : [String]
    let idKey = "lectureId"
    let nameKey = "lectureName"
    let lecturerKey = "lectureLecturer"
    let typeKey = "lectureType"
    let groupKey = "lectureGroup"
    let starttimeKey = "lectureStarttime"
    let endTimeKey = "lectureEndTime"
    let startdateKey = "lectureStartdate"
    let enddateKey = "lectureEnddate"
    let dayKey = "lectureDay"
    let roomKey = "lectureRoom"
    let selectedKey = "lectureSelected"
    let courseKey = "lectureCourse"
    let commentKey = "lectureComment"
    let eventIDsKey = "lectureEventIDs"
    
    init(id: Int, name: String, lecturer: String, type: String, group: String, starttime: Date, endTime: Date, startdate: Date, enddate: Date, day: String, room: String, course: String, comment : String, selected: Bool, eventIDs: [String]) {
        self.id = id
        self.name = name
        self.lecturer = lecturer
        self.type = type
        self.group = group
        self.starttime = starttime
        self.endTime = endTime
        self.startdate = startdate
        self.enddate = enddate
        self.day = day
        self.room = room
        self.selected = selected
        self.course = course
        self.comment = comment
        self.eventIDs = eventIDs
    }
    
    convenience init(id: Int, name: String, lecture: String, type: String, group: String, starttime: Date, endTime: Date, startdate: Date, enddate: Date, day: String, room: String, course: String, comment : String, eventIDs: [String]) {
        
        self.init(id: id, name: name, lecturer: lecture, type:type, group: group, starttime: starttime, endTime: endTime, startdate: startdate, enddate: enddate, day: day, room: room, course: course, comment: comment, selected: false, eventIDs: eventIDs)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Lecture(id: self.id, name: self.name, lecturer: self.lecturer, type: self.type, group: self.group, starttime: self.starttime, endTime: self.endTime, startdate: self.startdate, enddate: self.enddate, day: self.day, room: self.room, course: self.course, comment: self.comment, selected: self.selected, eventIDs: self.eventIDs)
        return copy
    }
    
    static func == (lhs: Lecture, rhs: Lecture) -> Bool {
        return (lhs.name == rhs.name) && (lhs.room == rhs.room) && (lhs.day == rhs.day) && (lhs.starttime == rhs.starttime)
    }
    
    override var hashValue: Int {
        return "\(name)\(room)\(day)\(starttime)".hashValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = Int(aDecoder.decodeInteger(forKey: idKey))
        name = aDecoder.decodeObject(forKey: nameKey) as! String
        lecturer = aDecoder.decodeObject(forKey: lecturerKey) as! String
        type = aDecoder.decodeObject(forKey: typeKey) as! String
        group = aDecoder.decodeObject(forKey: groupKey) as! String
        starttime = aDecoder.decodeObject(forKey: starttimeKey) as! Date
        endTime = aDecoder.decodeObject(forKey: endTimeKey) as! Date
        startdate = aDecoder.decodeObject(forKey: startdateKey) as! Date
        enddate = aDecoder.decodeObject(forKey: enddateKey) as! Date
        day = aDecoder.decodeObject(forKey: dayKey) as! String
        room = aDecoder.decodeObject(forKey: roomKey) as! String
        selected = Bool(aDecoder.decodeBool(forKey: selectedKey))
        course = aDecoder.decodeObject(forKey: courseKey) as! String
        comment = aDecoder.decodeObject(forKey: commentKey) as! String
        eventIDs = aDecoder.decodeObject(forKey: eventIDsKey) as! [String]
        super.init()
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(id, forKey: idKey)
        aCoder.encode(name, forKey: nameKey)
        aCoder.encode(lecturer, forKey: lecturerKey)
        aCoder.encode(type, forKey: typeKey)
        aCoder.encode(group, forKey: groupKey)
        aCoder.encode(starttime, forKey: starttimeKey)
        aCoder.encode(endTime, forKey: endTimeKey)
        aCoder.encode(startdate, forKey: startdateKey)
        aCoder.encode(enddate, forKey: enddateKey)
        aCoder.encode(day, forKey: dayKey)
        aCoder.encode(room, forKey: roomKey)
        aCoder.encode(selected, forKey: selectedKey)
        aCoder.encode(course, forKey: courseKey)
        aCoder.encode(comment, forKey: commentKey)
        aCoder.encode(eventIDs, forKey: eventIDsKey)
    }
    
}
