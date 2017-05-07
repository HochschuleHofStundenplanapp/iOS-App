//
//  Lecture.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 26.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class Lecture: NSObject, NSCoding {

    var id: Int
    var name: String
    var lecturer: String
    var type: String
    var group: String
    var startdate: Date
    var enddate: Date
    var day: String
    var room: String
    var semester: Semester
    var comment : String
    var iteration : Int
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
    let semesterKey = "lectureSemester"
    let commentKey = "lectureComment"
    let iterationKey = "lectureIteration"
    
    init(id: Int, name: String, lecturer: String, type: String, group: String, startdate: Date, enddate: Date, day: String, room: String, semester: Semester, comment : String, iteration: Int) {
        self.id = id
        self.name = name
        self.lecturer = lecturer
        self.type = type
        self.group = group
        self.startdate = startdate
        self.enddate = enddate
        self.day = day
        self.room = room
        self.semester = semester
        self.comment = comment
        self.iteration = iteration
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
        id = Int(aDecoder.decodeInteger(forKey: idKey))
        name = aDecoder.decodeObject(forKey: nameKey) as! String
        lecturer = aDecoder.decodeObject(forKey: lecturerKey) as! String
        type = aDecoder.decodeObject(forKey: typeKey) as! String
        group = aDecoder.decodeObject(forKey: groupKey) as! String
        startdate = aDecoder.decodeObject(forKey: startdateKey) as! Date
        enddate = aDecoder.decodeObject(forKey: enddateKey) as! Date
        day = aDecoder.decodeObject(forKey: dayKey) as! String
        room = aDecoder.decodeObject(forKey: roomKey) as! String
        semester = aDecoder.decodeObject(forKey: semesterKey) as! Semester
        comment = aDecoder.decodeObject(forKey: commentKey) as! String
        iteration = Int(aDecoder.decodeInteger(forKey: iterationKey))
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
        aCoder.encode(semester, forKey: semesterKey)
        aCoder.encode(comment, forKey: commentKey)
        aCoder.encode(iteration, forKey: iterationKey)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return self == object as! Lecture
    }
    
    static func == (lhs: Lecture, rhs: Lecture) -> Bool {
        return (lhs.id == rhs.id) && (lhs.name == rhs.name) && (lhs.room == rhs.room) && (lhs.type == rhs.type) && (lhs.day == rhs.day) && (lhs.semester == rhs.semester)
    }
}
