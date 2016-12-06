//
//  Lecture.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 18.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

//Vorlesung
class Lecture : Hashable, NSCopying {

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

    init(id: Int, name: String, lecturer: String, type: String, group: String, starttime: Date, endTime: Date, startdate: Date, enddate: Date, day: String, room: String, course: String, comment : String, selected: Bool) {
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
    }
    
    convenience init(id: Int, name: String, lecture: String, type: String, group: String, starttime: Date, endTime: Date, startdate: Date, enddate: Date, day: String, room: String, course: String, comment : String) {
        
        self.init(id: id, name: name, lecturer: lecture, type:type, group: group, starttime: starttime, endTime: endTime, startdate: startdate, enddate: enddate, day: day, room: room, course: course, comment: comment, selected: false)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Lecture(id: self.id, name: self.name, lecturer: self.lecturer, type: self.type, group: self.group, starttime: self.starttime, endTime: self.endTime, startdate: self.startdate, enddate: self.enddate, day: self.day, room: self.room, course: self.course, comment: self.comment, selected: self.selected)
        return copy
    }

     static func == (lhs: Lecture, rhs: Lecture) -> Bool {
        return (lhs.name == rhs.name) && (lhs.room == rhs.room) && (lhs.day == rhs.day) && (lhs.starttime == rhs.starttime)
    }
    
    var hashValue: Int {
        return "\(name)\(room)\(day)\(starttime)".hashValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "lectureId") as! Int
        name = aDecoder.decodeObject(forKey: "lectureName") as! String
        lecturer = aDecoder.decodeObject(forKey: "lectureLecturer") as! String
        type = aDecoder.decodeObject(forKey: "lectureType") as! String
        group = aDecoder.decodeObject(forKey: "lectureGroup") as! String
        starttime = aDecoder.decodeObject(forKey: "lectureStarttime") as! Date
        endTime = aDecoder.decodeObject(forKey: "lectureEndTime") as! Date
        startdate = aDecoder.decodeObject(forKey: "lectureStartdate") as! Date
        enddate = aDecoder.decodeObject(forKey: "lectureEnddate") as! Date
        day = aDecoder.decodeObject(forKey: "lectureDay") as! String
        room = aDecoder.decodeObject(forKey: "lectureRoom") as! String
        selected = aDecoder.decodeObject(forKey: "lectureSelected") as! Bool
        course = aDecoder.decodeObject(forKey: "lectureCourse") as! String
        comment = aDecoder.decodeObject(forKey: "lectureComment") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encode(id, forKey:"lectureId")
        aCoder.encode(name, forKey:"lectureName")
        aCoder.encode(lecturer, forKey:"lectureLecturer")
        aCoder.encode(type, forKey:"lectureType")
        aCoder.encode(group, forKey:"lectureGroup")
        aCoder.encode(starttime, forKey:"lectureStarttime")
        aCoder.encode(endTime, forKey:"lectureEndTime")
        aCoder.encode(startdate, forKey:"lectureStartdate")
        aCoder.encode(enddate, forKey:"lectureEnddate")
        aCoder.encode(day, forKey:"lectureDay")
        aCoder.encode(room, forKey:"lectureRoom")
        aCoder.encode(selected, forKey:"lectureSelected")
        aCoder.encode(course, forKey:"lectureCourse")
        aCoder.encode(comment, forKey:"lectureComment")
    }

}
