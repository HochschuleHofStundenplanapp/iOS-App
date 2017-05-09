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
    
    // var newEventIDs : [String]
    
    var id: Int
    var name: String
    var lecturer: String
    var type: String
    var group: String
    var startdate: Date
    var enddate: Date
    var day: String
    var room: String
    var selected: Bool
    var course: Course
    var semester: Semester
    var comment : String
    var eventIDs : [String]
    var iteration : iterationState
    let idKey = "lectureId"
    let nameKey = "lectureName"
    let lecturerKey = "lectureLecturer"
    let typeKey = "lectureType"
    let groupKey = "lectureGroup"
    let startdateKey = "lectureStartdate"
    let enddateKey = "lectureEnddate"
    let dayKey = "lectureDay"
    let roomKey = "lectureRoom"
    let selectedKey = "lectureSelected"
    let courseKey = "lectureCourse"
    let semesterKey = "lectureSemester"
    let commentKey = "lectureComment"
    let eventIDsKey = "lectureEventIDs"
    let iterationKey = "lectureIteration"
    
    init(id: Int, name: String, lecturer: String, type: String, group: String, startdate: Date, enddate: Date, day: String, room: String, course: Course, semester: Semester, comment : String, selected: Bool, eventIDs: [String], iteration: iterationState) {
        self.id = id
        self.name = name
        self.lecturer = lecturer
        self.type = type
        self.group = group
        self.startdate = startdate
        self.enddate = enddate
        self.day = day
        self.room = room
        self.selected = selected
        self.course = course
        self.semester = semester
        self.comment = comment
        self.eventIDs = eventIDs
        self.iteration = iteration
    }
    
    convenience init(id: Int, name: String, lecture: String, type: String, group: String, startdate: Date, enddate: Date, day: String, room: String, course: Course,semester: Semester, comment : String, eventIDs: [String], iteration: iterationState) {
        
        self.init(id: id, name: name, lecturer: lecture, type:type, group: group, startdate: startdate, enddate: enddate, day: day, room: room, course: course, semester: semester, comment: comment, selected: false, eventIDs: eventIDs, iteration: iteration )
    }
    
    var startTime: Date {
        get {
            let calendar = Calendar.current
            
            let hour = calendar.component(.hour, from: startdate)
            let minutes = calendar.component(.minute, from: startdate)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.locale = Locale(identifier: "de_DE")
            let start = dateFormatter.date(from:"\(hour) \(minutes)")
            
            return start!
        }
    }
    
    var endTime: Date {
        get {
            let calendar = Calendar.current
            
            let hour = calendar.component(.hour, from: enddate)
            let minutes = calendar.component(.minute, from: enddate)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.locale = Locale(identifier: "de_DE")
            let end = dateFormatter.date(from:"\(hour) \(minutes)")
            
            return end!
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        var newEventIDs = [String]()
        
        for id in eventIDs {
            newEventIDs.append(id.copy() as! String)
        }
        
        let copy = Lecture(id: self.id, name: self.name, lecturer: self.lecturer, type: self.type, group: self.group, startdate: self.startdate, enddate: self.enddate, day: self.day, room: self.room, course: self.course, semester: self.semester, comment: self.comment, selected: self.selected, eventIDs: newEventIDs, iteration: self.iteration)
        return copy
    }
    
    static func == (lhs: Lecture, rhs: Lecture) -> Bool {
        return (lhs.name == rhs.name) && (lhs.room == rhs.room) && (lhs.course.contraction == rhs.course.contraction) && (lhs.day == rhs.day) && (lhs.startdate == rhs.enddate) && (lhs.group == rhs.group)
    }
    
    override var hashValue: Int {
        return "\(name)\(room)\(day)\(startTime)".hashValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = Int(aDecoder.decodeInteger(forKey: idKey))
        name = aDecoder.decodeObject(forKey: nameKey) as! String
        lecturer = aDecoder.decodeObject(forKey: lecturerKey) as! String
        type = aDecoder.decodeObject(forKey: typeKey) as! String
        group = aDecoder.decodeObject(forKey: groupKey) as! String
        startdate = aDecoder.decodeObject(forKey: startdateKey) as! Date
        enddate = aDecoder.decodeObject(forKey: enddateKey) as! Date
        day = aDecoder.decodeObject(forKey: dayKey) as! String
        room = aDecoder.decodeObject(forKey: roomKey) as! String
        selected = Bool(aDecoder.decodeBool(forKey: selectedKey))
        course = aDecoder.decodeObject(forKey: courseKey) as! Course
        semester = aDecoder.decodeObject(forKey: semesterKey) as! Semester
        comment = aDecoder.decodeObject(forKey: commentKey) as! String
        eventIDs = aDecoder.decodeObject(forKey: eventIDsKey) as! [String]
        iteration = aDecoder.decodeObject(forKey: iterationKey) as! iterationState
        super.init()
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(id, forKey: idKey)
        aCoder.encode(name, forKey: nameKey)
        aCoder.encode(lecturer, forKey: lecturerKey)
        aCoder.encode(type, forKey: typeKey)
        aCoder.encode(group, forKey: groupKey)
        aCoder.encode(startdate, forKey: startdateKey)
        aCoder.encode(enddate, forKey: enddateKey)
        aCoder.encode(day, forKey: dayKey)
        aCoder.encode(room, forKey: roomKey)
        aCoder.encode(selected, forKey: selectedKey)
        aCoder.encode(course, forKey: courseKey)
        aCoder.encode(semester, forKey: semesterKey)
        aCoder.encode(comment, forKey: commentKey)
        aCoder.encode(eventIDs, forKey: eventIDsKey)
        aCoder.encode(iteration, forKey: iterationKey)
    }
}

enum iterationState: Int {
    case individualDate = 0
    case daily = 1
    case weekly = 7
    case twoWeeks = 14
    case calendarWeeks = -1
    case notParsable = -2
}
