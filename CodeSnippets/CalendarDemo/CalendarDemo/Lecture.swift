//
//  Lecture.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 18.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

//Vorlesung
class Lecture{

    var id: Int
    var name: String
    var docent: String
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
    
    //Comment ergänzen

    init(id: Int, name: String, docent: String, type: String, group: String, starttime: Date, endTime: Date, startdate: Date, enddate: Date, day: String, room: String, course: String) {
        self.id = id
        self.name = name
        self.docent = docent
        self.type = type
        self.group = group
        self.starttime = starttime
        self.endTime = endTime
        self.startdate = startdate
        self.enddate = enddate
        self.day = day
        self.room = room
        self.selected = false
        self.course = course
    }

}
