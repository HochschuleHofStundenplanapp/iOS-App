//
//  Course.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 12.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

// Studiengang
class Course: NSCopying {
    
    var contraction : String
    var nameDe: String
    var nameEn: String
    var semesters: Semesters
    var selected: Bool
    
    init(contraction : String, nameDe: String, nameEn: String, semesters: Semesters, selected: Bool) {
        self.contraction = contraction
        self.semesters = semesters
        self.nameDe = nameDe
        self.nameEn = nameEn
        self.selected = false
    }
    
    convenience init(contraction : String, nameDe: String, nameEn: String, semesters: Semesters) {
        self.init(contraction : contraction, nameDe: nameDe, nameEn: nameEn, semesters: semesters, selected: false)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Course(contraction: self.contraction, nameDe: self.nameDe, nameEn: self.nameEn, semesters: self.semesters, selected: self.selected)
        return copy
    }
    
    func equal(compareTo: Course) -> Bool {
        return self.contraction == compareTo.contraction
    }
    
}
