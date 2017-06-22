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
    var savedSplusnames : [String] = [String]()//Auslagern
    var selectedSchedule: Schedule = Schedule()
    
    static var sharedInstance = UserData()
    private override init(){ }
    
    override func copy() -> Any {
        let copy = UserData()
        copy.selectedSeason = selectedSeason
        copy.selectedCourses = selectedCourses
        copy.selectedSemesters = selectedSemesters
        copy.selectedSchedule = selectedSchedule.copy() as! Schedule
        return copy
    }
}
