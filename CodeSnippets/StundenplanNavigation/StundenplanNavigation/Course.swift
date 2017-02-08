//
//  Course.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 12.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

// Studiengang
class Course: NSObject, NSCopying, NSCoding {
    
    var contraction : String
    var nameDe: String
    var nameEn: String
    var semesters: Semesters
    var selected: Bool
    let contractionKey = "courseContraction"
    let nameDeKey = "courseNameDe"
    let nameEnKey = "courseNameEn"
    let semestersKey = "courseSemesters"
    let selectedKey = "courseSelected"
    
    init(contraction : String, nameDe: String, nameEn: String, semesters: Semesters, selected: Bool) {
        self.contraction = contraction
        self.semesters = semesters.copy() as! Semesters
        self.nameDe = nameDe
        self.nameEn = nameEn
        self.selected = selected
    }
    
    convenience init(contraction : String, nameDe: String, nameEn: String, semesters: Semesters) {
        self.init(contraction : contraction, nameDe: nameDe, nameEn: nameEn, semesters: semesters, selected: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        contraction = aDecoder.decodeObject(forKey: contractionKey) as! String
        nameDe = aDecoder.decodeObject(forKey: nameDeKey) as! String
        nameEn = aDecoder.decodeObject(forKey: nameEnKey) as! String
        semesters = aDecoder.decodeObject(forKey: semestersKey) as! Semesters
        selected = Bool(aDecoder.decodeBool(forKey: selectedKey))
        super.init()
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(contraction, forKey: contractionKey)
        aCoder.encode(nameDe, forKey: nameDeKey)
        aCoder.encode(nameEn, forKey: nameEnKey)
        aCoder.encode(semesters, forKey: semestersKey)
        aCoder.encode(selected, forKey: selectedKey)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Course(contraction: self.contraction, nameDe: self.nameDe, nameEn: self.nameEn, semesters: self.semesters, selected: self.selected)
        return copy
    }
    
    func equal(compareTo: Course) -> Bool {
        return self.contraction == compareTo.contraction
    }
    
}
