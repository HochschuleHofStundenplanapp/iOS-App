//
//  UserData.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 27.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit
/**
 Speichert die **vom User ausgewählten** Infos über
 * Season -> Sommer- oder Wintersemester
 * Courses -> Studiengänge mit gewählten Semestern
 * Semesters -> Semester mit Studiengängen
 * Lectures -> Vorlesungen mit Info über das zugehörige Semester
 */
class UserData: NSObject {

    var callenderSync: Bool = false
    var selectedSeason : String = "SS"
    var selectedCourses : [Course] = []
    var selectedSemesters : [Semester] = []
    //var selectedLectures: [Lecture] = []
    var savedSplusnames : [String] = [String]()
    var selectedLectures: Schedule = Schedule()
    
    static var sharedInstance = UserData()
    private override init(){ }

    func coursesSize() -> Int {
        return selectedCourses.count
    }
        
    func semesterSize(at section: Int) -> Int{
        return selectedCourses[section].semesters.count
    }
    
    func semester(at indexPath: IndexPath) -> Semester{
        return selectedCourses[indexPath.section].semesters[indexPath.row]
    }
    
    func courseName(at section: Int) -> String {
        return selectedCourses[section].nameDe
    }
    
    // Erweiterung des Modells um die Label-Texte im Settings-Screen zu erzeugen
    // Da Daten nicht sortiert sind, kommt es wohl besser in einen Controller 
    func allSelectedCourses() -> String
    {
        if selectedCourses.count == 0
        {
            return "..."
        }
        
        var res = ""
        var sep = ""
        for c in selectedCourses
        {
            res += sep + c.contraction
            sep = "|"
        }
        return res
    }
    
    func allSelectedSemesters() -> String
    {
        if selectedSemesters.count == 0
        {
            return "..."
        }

        var res = ""
        var sep = ""
        var lastCourseName = ""
        
        for s in selectedSemesters
        {
            if (lastCourseName == "")
            {
                sep = ""
            }
            else if (s.course.contraction == lastCourseName)
            {
                sep = ","
            }
            else {
                sep = "|"
            }

            res += sep + s.name
            lastCourseName = s.course.contraction
        }
        
        return res
    }
}
