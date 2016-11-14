//
//  Course.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 12.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import Foundation

class Course {
    
    var contraction : String
    var nameDe: String
    var nameEn: String
    var semester: [String]
    //boolean ob der Studienganb vom User gewählt worden ist
    var selected: Bool
    //Speichert welche Semseter zum Studeingang gewählt wurden
    var selectedSemesters : [String] 
    
    init(contraction : String, nameDe: String, nameEn: String, semester: [String]) {
        self.contraction = contraction
        self.semester = semester
        self.nameDe = nameDe
        self.nameEn = nameEn
        self.selected = false
        self.selectedSemesters = []
    }
    
}
