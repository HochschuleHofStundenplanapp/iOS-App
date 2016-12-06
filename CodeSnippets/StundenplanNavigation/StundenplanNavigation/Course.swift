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
    
    required init?(coder aDecoder: NSCoder) {
        contraction = aDecoder.decodeObject(forKey: "courseContraction") as! String
        nameDe = aDecoder.decodeObject(forKey: "courseNameDe") as! String
        nameEn = aDecoder.decodeObject(forKey: "courseNameEn") as! String
        semesters = aDecoder.decodeObject(forKey: "courseSemesters") as! Semesters
        selected = aDecoder.decodeObject(forKey: "courseSelected") as! Bool
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encode(contraction, forKey:"courseContraction")
        aCoder.encode(nameDe, forKey:"courseNameDe")
        aCoder.encode(nameEn, forKey:"courseNameEn")
        aCoder.encode(semesters, forKey:"courseSemesters")
        aCoder.encode(selected, forKey:"courseSelected")
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Course(contraction: self.contraction, nameDe: self.nameDe, nameEn: self.nameEn, semesters: self.semesters, selected: self.selected)
        return copy
    }
    
    func equal(compareTo: Course) -> Bool {
        return self.contraction == compareTo.contraction
    }
    
}
