//
//  Semester.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 15.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class Semester: NSObject {
    var name: String
    var selected: Bool
    
    init(name: String) {
        self.name = name
        self.selected = false
    }
    
    func equal(compareTo: Semester) -> Bool {
        return self.name == compareTo.name
    }
}
