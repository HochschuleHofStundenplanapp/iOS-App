//
//  TmpSelectedSemesters.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 08.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class TmpSelectedSemesters: NSObject {

    fileprivate var userdata = UserData.sharedInstance
    
    func numberOfEntries(for section : Int) -> Int
    {
        return userdata.selectedCourses[section].semesters.count
    }
    
    func contains(semester: Semester) -> Bool{
        return userdata.selectedSemesters.contains(semester)
    }
    
    func append(semester : Semester) {
        userdata.selectedSemesters.append(semester)
    }
    
    func remove(semester: Semester){
        let index = userdata.selectedSemesters.index(of: semester)
        userdata.selectedSemesters.remove(at: index!)
    }
    
    func semester(at indexPath: IndexPath) -> Semester{
        return userdata.selectedCourses[indexPath.section].semesters[indexPath.row]
    }
    
    func allSemesters() -> [Semester]{
        return UserData.sharedInstance.selectedSemesters
    }
    
    func removeSemester(with course: Course){
        for semester in UserData.sharedInstance.selectedSemesters{
            if(semester.course == course){
                let index = UserData.sharedInstance.selectedSemesters.index(of: semester)
                UserData.sharedInstance.selectedSemesters.remove(at: index!)
            }
        }
    }
    
    func allSelectedSemesters() -> String
    {
        if userdata.selectedSemesters.count == 0
        {
            return "..."
        }
        
        var res = ""
        var sep = ""
        
        
        var selCourses = userdata.selectedCourses
        var semesters : [[Semester]] = []
        
        for i in 0..<selCourses.count{
            semesters.append([Semester]())
        }
        
        
        for s in userdata.selectedSemesters
        {
            
        }
        
        
        //            if ("" == "")
        //            {
        //                sep = ""
        //            }
        //            else if (s.course.contraction == "")
        //            {
        //                sep = ","
        //            }
        //            else {
        //                sep = "|"
        //            }
        //            
        //            res += sep + s.name

        return res
    }
}
