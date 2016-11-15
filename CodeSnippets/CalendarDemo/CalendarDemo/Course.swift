//
//  Course.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 12.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

// Studiengang
class Course {
    
    var contraction : String
    var nameDe: String
    var nameEn: String
    var semesters: Semesters
    var selected: Bool
    
    init(contraction : String, nameDe: String, nameEn: String, semesters: Semesters) {
        self.contraction = contraction
        self.semesters = semesters
        self.nameDe = nameDe
        self.nameEn = nameEn
        self.selected = false
    }
    
}
