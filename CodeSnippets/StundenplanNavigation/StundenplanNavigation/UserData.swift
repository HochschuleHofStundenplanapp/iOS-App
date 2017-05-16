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
    var selectedLectures: [Lecture] = []
    
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
}
