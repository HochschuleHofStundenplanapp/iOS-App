//
//  TmpSelectedCourses.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 08.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class TmpSelectedCourses: NSObject {

    fileprivate var userdata: UserData
    
    init(userdata: UserData){
        self.userdata = userdata
    }
    
    func numberOfEntries() -> Int {
        return userdata.selectedCourses.count
    }
    
    func append(course : Course) {
        userdata.selectedCourses.append(course)
    }
    
    func contains(course: Course) -> Bool{
        return userdata.selectedCourses.contains(course)
    }
    
    func courseName(at section: Int) -> String {
        return userdata.selectedCourses[section].nameDe
    }
    
    func remove(course: Course){
        let index = userdata.selectedCourses.index(of: course)
        userdata.selectedCourses.remove(at: index!)
    }
    
    func hasSelection() -> Bool{
        return !userdata.selectedCourses.isEmpty
    }
    
    // Erweiterung des Modells um die Label-Texte im Settings-Screen zu erzeugen
    // Da Daten nicht sortiert sind, kommt es wohl besser in einen Controller
    func allSelectedCourses() -> String
    {
        if userdata.selectedCourses.count == 0
        {
            return "..."
        }
        
        //Vorher sortieren
        userdata.selectedCourses.sort(by: {$0.nameDe < $1.nameDe})
        
        
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
