//
//  SemesterController.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 07.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class SemesterController: NSObject {

    func toggleSemester(at indexPath: IndexPath) {
        
        let clickedCourse = ServerData.sharedInstance.allCourses[indexPath.row]
        
        if UserData.sharedInstance.selectedCourses.contains(clickedCourse) {
            let index = UserData.sharedInstance.selectedCourses.index(of: clickedCourse)
            UserData.sharedInstance.selectedCourses.remove(at: index!)
        }else{
            UserData.sharedInstance.selectedCourses.append(clickedCourse)
        }
    }
}
