//
//  Lecture.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 26.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class Lecture: NSObject, NSCoding {

    var key: String //splusname+semester+lecture
    var id: Int
    var splusname: String
    var name: String
    var lecturer: String
    var type: String
    var style: String
    var group: String
    var startdate: Date
    var enddate: Date
    var day: String
    var room: String
    var semester: Semester
    var comment : String
    var iteration : iterationState
    var kwDates : [Date]
    let keyKey = "lectureKey"
    let idKey = "lectureId"
    let splusnameKey = "lectureSplusname"
    let nameKey = "lectureName"
    let lecturerKey = "lectureLecturer"
    let styleKey = "lectureStyle"
    let typeKey = "lectureType"
    let groupKey = "lectureGroup"
    let startdateKey = "lectureStartdate"
    let enddateKey = "lectureEnddate"
    let dayKey = "lectureDay"
    let roomKey = "lectureRoom"
    let selectedKey = "lectureSelected"
    let semesterKey = "lectureSemester"
    let commentKey = "lectureComment"
    let iterationKey = "lectureIteration"
    let kwDatesKey = "kwDates"
    
    init(id: Int, splusname: String, name: String, lecturer: String, type: String, style: String, group: String, startdate: Date, enddate: Date, day: String, room: String, semester: Semester, comment : String, iteration: iterationState, kwDates: [Date]) {
        self.key = splusname + semester.name + semester.course.contraction
        self.id = id
        self.splusname = splusname
        self.name = name
        self.lecturer = lecturer
        self.type = type
        self.style = style
        self.group = group
        self.startdate = startdate
        self.enddate = enddate
        self.day = day
        self.room = room
        self.semester = semester
        self.comment = comment
        self.iteration = iteration
        self.kwDates = kwDates
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
    
    required init?(coder aDecoder: NSCoder) {
        key = aDecoder.decodeObject(forKey: keyKey) as! String
        id = Int(aDecoder.decodeInteger(forKey: idKey))
        splusname = aDecoder.decodeObject(forKey: splusnameKey) as! String
        name = aDecoder.decodeObject(forKey: nameKey) as! String
        lecturer = aDecoder.decodeObject(forKey: lecturerKey) as! String
        type = aDecoder.decodeObject(forKey: typeKey) as! String
        style = aDecoder.decodeObject(forKey: styleKey) as! String
        group = aDecoder.decodeObject(forKey: groupKey) as! String
        startdate = aDecoder.decodeObject(forKey: startdateKey) as! Date
        enddate = aDecoder.decodeObject(forKey: enddateKey) as! Date
        day = aDecoder.decodeObject(forKey: dayKey) as! String
        room = aDecoder.decodeObject(forKey: roomKey) as! String
        semester = aDecoder.decodeObject(forKey: semesterKey) as! Semester
        comment = aDecoder.decodeObject(forKey: commentKey) as! String
        iteration = iterationState(rawValue: Int(aDecoder.decodeInteger(forKey: iterationKey)))!
        kwDates = aDecoder.decodeObject(forKey: kwDatesKey) as! [Date]
        super.init()
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(key, forKey: keyKey)
        aCoder.encode(id, forKey: idKey)
        aCoder.encode(splusname, forKey: splusnameKey)
        aCoder.encode(name, forKey: nameKey)
        aCoder.encode(lecturer, forKey: lecturerKey)
        aCoder.encode(type, forKey: typeKey)
        aCoder.encode(style, forKey: styleKey)
        aCoder.encode(group, forKey: groupKey)
        aCoder.encode(startdate, forKey: startdateKey)
        aCoder.encode(enddate, forKey: enddateKey)
        aCoder.encode(day, forKey: dayKey)
        aCoder.encode(room, forKey: roomKey)
        aCoder.encode(semester, forKey: semesterKey)
        aCoder.encode(comment, forKey: commentKey)
        aCoder.encode(iteration.rawValue, forKey: iterationKey)
        aCoder.encode(kwDates, forKey: kwDatesKey)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        let rhs = object as! Lecture
        return (self == rhs)
    }
    
    func isEqual(to changeLecture: ChangedLecture) -> Bool{
        dump(self.startTime)
        dump(changeLecture.oldTime)
        return (self.name == changeLecture.name)
            && (self.room == changeLecture.oldRoom)
            && (self.day == changeLecture.oldDay)
            && (self.startTime == changeLecture.oldTime)

    }
    
    static func == (lhs: Lecture, rhs: Lecture) -> Bool {
//        return (lhs.id == rhs.id) && (lhs.name == rhs.name) && (lhs.room == rhs.room) && (lhs.type == rhs.type) && (lhs.day == rhs.day) && (lhs.semester == rhs.semester)
        return (lhs.key == rhs.key)
    }
}

enum iterationState: Int {
    case individualDate = 0
    case daily = 1
    case weekly = 7
    case twoWeeks = 14
    case calendarWeeks = -1
    case notParsable = -2
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .individualDate
        case 1:
            self = .daily
        case 7:
            self = .weekly
        case 14:
            self = .twoWeeks
        case -1:
            self = .calendarWeeks
        case -2:
            self = .notParsable
        default:
            return nil
        }
    }
}
