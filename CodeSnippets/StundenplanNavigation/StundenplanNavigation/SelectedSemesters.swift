//
//  SelectedSemesters.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 18.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class SelectedSemesters: NSObject {

    fileprivate var userdata = UserData.sharedInstance
    
    func numberOfEntries() -> Int
    {
        return userdata.selectedSemesters.count
    }
    
    func getElement(from i : Int) -> Semester
    {
        return userdata.selectedSemesters[i]
    }
    
    func set(element : Semester, at i : Int)
    {
        userdata.selectedSemesters[i] = element
    }
    
    func remove(at i : Int)
    {
        userdata.selectedSemesters.remove(at: i)
    }
    
    func append(element : Semester)
    {
        userdata.selectedSemesters.append(element)
    }
    
    func clear()
    {
        userdata.selectedSemesters = []
    }

}
