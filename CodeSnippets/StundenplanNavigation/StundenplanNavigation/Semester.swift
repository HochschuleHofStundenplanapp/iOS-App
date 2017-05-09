//
//  Semester.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 30.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class Semester: NSObject, NSCoding {

    var name: String
    var course: Course
    var season: String
    let nameKey = "semesterName"
    let courseKey = "semesterCourse"
    let seasonKey = "semesterSeason"

    init(name: String, course: Course, season: String) {
        self.name = name
        self.course = course
        self.season = season
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return self == object as! Semester
    }
    
    static func == (lhs: Semester, rhs: Semester) -> Bool {
        return (lhs.name == rhs.name) && (lhs.course == rhs.course) && (lhs.season == rhs.season)
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: nameKey) as! String
        course = aDecoder.decodeObject(forKey: courseKey) as! Course
        season = aDecoder.decodeObject(forKey: seasonKey) as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey: nameKey)
        aCoder.encode(course, forKey: courseKey)
        aCoder.encode(season, forKey: seasonKey)
    }
}
