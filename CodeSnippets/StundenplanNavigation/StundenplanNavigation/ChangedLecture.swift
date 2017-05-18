//
//  ChangedLecture.swift
//  StundenplanNavigation
//
//  Created by Andreas Wolf on 18.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import Foundation

class ChangedLecture {
    
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
    var course: Course
    var group: String
    
    //Studiengang einfügen
    
    init(id: Int, name: String, docent: String, comment: String,
         oldTime: Date, oldDate: Date, oldDay: String, oldRoom: String,
         newTime: Date?, newDate: Date?, newDay: String, newRoom: String, course: Course, group: String) {
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
        self.course = course
        self.group = group
    }
}
