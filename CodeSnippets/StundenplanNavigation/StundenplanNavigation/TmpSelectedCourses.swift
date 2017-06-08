//
//  TmpSelectedCourses.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 08.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class TmpSelectedCourses: NSObject {

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
    
    // Erweiterung des Modells um die Label-Texte im Settings-Screen zu erzeugen
    // Da Daten nicht sortiert sind, kommt es wohl besser in einen Controller
    func allSelectedCourses() -> String
    {
        if userdata.selectedCourses.count == 0
        {
            return "..."
        }
        
        var res = ""
        var sep = ""
        for c in userdata.selectedCourses
        {
            res += sep + c.contraction
            sep = "|"
        }
        return res
    }
}
