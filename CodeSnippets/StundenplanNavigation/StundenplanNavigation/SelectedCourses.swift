//
//  SelectedCourses.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 18.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class SelectedCourses: NSObject {

    fileprivate var userdata = UserData.sharedInstance
    
    func numberOfEntries() -> Int
    {
        return userdata.selectedCourses.count
    }
    
    func getElement(from i : Int) -> Course
    {
        return userdata.selectedCourses[i]
    }
    
    func set(element : Course, at i : Int)
    {
        userdata.selectedCourses[i] = element
    }
    
    func remove(at i : Int)
    {
        userdata.selectedCourses.remove(at: i)
    }
    
    func append(element : Course)
    {
        userdata.selectedCourses.append(element)
    }
    
    func clear()
    {
        userdata.selectedCourses = []
    }

}
