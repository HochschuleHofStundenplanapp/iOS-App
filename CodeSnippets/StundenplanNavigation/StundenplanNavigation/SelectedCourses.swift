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
    
    func numberOfEntries() -> Int {
        return userdata.selectedCourses.count
    }
    
    func courseName(at section: Int) -> String {
        return userdata.selectedCourses[section].nameDe
    }

    func remove(at indexPath: IndexPath){
        userdata.selectedCourses.remove(at: indexPath.row)
    }
    
    func contains(course: Course) -> Bool{
        return userdata.selectedCourses.contains(course)
    }
    
    func indexPath(of course: Course) -> IndexPath {
        let row = userdata.selectedCourses.index(of: course)!
        let iP = NSIndexPath(row: row, section: 0)
        return iP as IndexPath
    }
}
