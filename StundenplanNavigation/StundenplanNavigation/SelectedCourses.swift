//
//  SelectedCourses.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 18.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit
import StundenplanFramework

class SelectedCourses: NSObject {

    fileprivate var userdata = UserData.sharedInstance
    
    func contains(course: Course) -> Bool{
        return userdata.selectedCourses.contains(course)
    }
    
    
}
