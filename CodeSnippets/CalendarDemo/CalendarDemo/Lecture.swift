//
//  Lecture.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 18.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

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
    //boolean ob der Vorlesung vom User gewählt worden ist
    var selected: Bool

    init(id: Int, name: String, docent: String, type: String, group: String, starttime: Date, endTime: Date, startdate: Date, enddate: Date, day: String, room: String) {
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
    }

}
