//
//  ChangedLecture.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 18.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
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
    var newTime: Date
    var newDate: Date
    var newDay: String
    var newRoom: String 

    
    init(id: Int, name: String, docent: String, comment: String, oldTime: Date, oldDate: Date, oldDay: String, oldRoom: String, newTime: Date, newDate: Date, newDay: String, newRoom: String) {
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
    }

    
}
