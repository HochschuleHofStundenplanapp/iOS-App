//
//  Course.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 26.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class Course: NSObject, NSCoding  {

    var contraction: String
    var nameDe: String
    var nameEn: String
    var semesters: [Semester] = []
    let contractionKey = "courseContraction"
    let nameDeKey = "courseNameDe"
    let nameEnKey = "courseNameEn"
    let semesterKey = "courseSemesters"
    
    init(contraction : String, nameDe: String, nameEn: String) {
        self.contraction = contraction
        self.nameDe = nameDe
        self.nameEn = nameEn
    }
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        return (lhs.contraction == rhs.contraction) && (lhs.nameDe == rhs.nameDe) && (lhs.nameEn == rhs.nameEn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        contraction = aDecoder.decodeObject(forKey: contractionKey) as! String
        nameDe = aDecoder.decodeObject(forKey: nameDeKey) as! String
        nameEn = aDecoder.decodeObject(forKey: nameEnKey) as! String
        semesters = aDecoder.decodeObject(forKey: semesterKey) as! [Semester]
        super.init()
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(contraction, forKey: contractionKey)
        aCoder.encode(nameDe, forKey: nameDeKey)
        aCoder.encode(nameEn, forKey: nameEnKey)
        aCoder.encode(semesters, forKey: semesterKey)
    }
}
