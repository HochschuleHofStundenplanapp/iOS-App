//
//  Semester.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 15.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class Semester: NSCopying {
    var name: String
    var selected: Bool
    
    init(name: String, selected: Bool) {
        self.name = name
        self.selected = selected
    }
    
    convenience init(name: String){
        self.init(name: name, selected: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "semesterName") as! String
        selected = aDecoder.decodeObject(forKey: "semesterSelected") as! Bool
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encode(name, forKey:"semesterName")
        aCoder.encode(selected, forKey:"semesterSelected")
    }

    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Semester(name: self.name, selected: self.selected)
        return copy
    }
    
    func equal(compareTo: Semester) -> Bool {
        return self.name == compareTo.name
    }
}
