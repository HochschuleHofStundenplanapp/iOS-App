//
//  Semester.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 30.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

public class Semester: NSObject, NSCoding {

    public var name: String
    public var course: Course!
    let nameKey = "semesterName"
    let courseKey = "semesterCourse"
    
    public init(name: String, course: Course) {
        self.name = name
        self.course = course
    }
        
    override public func isEqual(_ object: Any?) -> Bool {
        return self == object as! Semester
    }
    
    static func == (lhs: Semester, rhs: Semester) -> Bool {
        return (lhs.name == rhs.name) && (lhs.course == rhs.course)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: nameKey) as! String
        course = aDecoder.decodeObject(forKey: courseKey) as! Course
        super.init()
    }
    
    public func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey: nameKey)
        aCoder.encode(course, forKey: courseKey)
    }
}
