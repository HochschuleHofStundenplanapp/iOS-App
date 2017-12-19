//
//  Course.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 26.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

public class Course: NSObject, NSCoding {

    public var contraction: String
    public var nameDe: String
    public var nameEn: String
    public var semesters: [Semester] = []
    let contractionKey = "courseContraction"
    let nameDeKey = "courseNameDe"
    let nameEnKey = "courseNameEn"
    let semesterKey = "courseSemesters"
    
    public init(contraction : String, nameDe: String, nameEn: String) {
        self.contraction = contraction
        self.nameDe = nameDe
        self.nameEn = nameEn
    }
    
//    init(contraction : String, nameDe: String, nameEn: String, semesters: [Semester]) {
//        self.contraction = contraction
//        self.nameDe = nameDe
//        self.nameEn = nameEn
//        self.semesters = semesters
//    }
//    
//    func copy(with zone: NSZone? = nil) -> Any {
//        let copy = Course(contraction: contraction, nameDe: nameDe, nameEn: nameEn, semesters: semesters)
//        return copy
//    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        return self == object as! Course
    }
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        return (lhs.contraction == rhs.contraction) && (lhs.nameDe == rhs.nameDe) && (lhs.nameEn == rhs.nameEn)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        contraction = aDecoder.decodeObject(forKey: contractionKey) as! String
        nameDe = aDecoder.decodeObject(forKey: nameDeKey) as! String
        nameEn = aDecoder.decodeObject(forKey: nameEnKey) as! String
        semesters = aDecoder.decodeObject(forKey: semesterKey) as! [Semester]
        super.init()
    }
    
    public func encode(with aCoder: NSCoder){
        aCoder.encode(contraction, forKey: contractionKey)
        aCoder.encode(nameDe, forKey: nameDeKey)
        aCoder.encode(nameEn, forKey: nameEnKey)
        aCoder.encode(semesters, forKey: semesterKey)
    }
}
