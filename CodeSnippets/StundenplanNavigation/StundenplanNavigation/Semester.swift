//
//  Semester.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 15.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class Semester: NSObject, NSCopying, NSCoding {
    var name: String
    var selected: Bool
    let nameKey = "semesterName"
    let selectedKey = "semesterSelected"
    
    init(name: String, selected: Bool) {
        self.name = name
        self.selected = selected
    }
    
    convenience init(name: String){
        self.init(name: name, selected: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: nameKey) as! String
        selected = Bool(aDecoder.decodeBool(forKey: selectedKey))
        super.init()

    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey: nameKey)
        aCoder.encode(selected, forKey: selectedKey)
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Semester(name: self.name, selected: self.selected)
        return copy
    }
    
    func equal(compareTo: Semester) -> Bool {
        return self.name == compareTo.name
    }
}
