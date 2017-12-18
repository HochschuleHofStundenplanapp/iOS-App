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
class UserData: NSObject, NSCoding{

    static var sharedInstance = UserData()
    
    var calenderSync: Bool = false
    var selectedSeason : String = Date().checkSemester()
    var selectedCourses : [Course] = []
    var selectedSemesters : [Semester] = []
    var savedSplusnames : [String] = [String]()//Auslagern
    var selectedSchedule: Schedule = Schedule()
    var oldChanges : [ChangedLecture] = []
    var tasks: [Task] = []
    
    
    var calendarIdentifier: String?
    
    var removedLectures: [Lecture] = []
    var addedLectures: [Lecture] = []
    let callenderSyncKey = "callenderSync"
    let selectedSeasonKey = "selectedSeason"
    let selectedCoursesKey = "selectedCourses"
    let selectedSemestersKey = "selectedSemesters"
    let savedSplusnamesKey = "savedSplusnames"
    let selectedScheduleKey = "selectedSchedule"
    let removedLecturesKey = "removedLectures"
    let addedLecturesKey = "addedLectures"
    let oldChangesKey = "oldChanges"
    let tasksKey = "taskKey"
    let calendarIdentifierKey = "calendarIdentifier"
    let appcolorKey = "appcolor"

    private override init(){}
    
    override func copy() -> Any {
        let copy = UserData()
        copy.selectedSeason = selectedSeason
        copy.selectedCourses = selectedCourses
        copy.selectedSemesters = selectedSemesters
        copy.selectedSchedule = selectedSchedule.copy() as! Schedule
        
        copy.removedLectures = removedLectures
        copy.addedLectures = addedLectures
        copy.calenderSync = calenderSync
        copy.calendarIdentifier = calendarIdentifier
        copy.tasks = tasks
        return copy
    }

    func wipeUserData(){
//        calenderSync = false
        selectedSeason = Date().checkSemester()
        selectedCourses = []
        selectedSemesters = []
        savedSplusnames = [String]()//Auslagern
        selectedSchedule = Schedule()
        oldChanges = []
    }
    
    required init?(coder aDecoder: NSCoder) {
        calenderSync = aDecoder.decodeBool(forKey: callenderSyncKey)
        selectedSeason = aDecoder.decodeObject(forKey: selectedSeasonKey) as! String
        selectedCourses = aDecoder.decodeObject(forKey: selectedCoursesKey) as! [Course]
        selectedSemesters = aDecoder.decodeObject(forKey: selectedSemestersKey) as! [Semester]
        savedSplusnames = aDecoder.decodeObject(forKey: savedSplusnamesKey) as! [String]
        selectedSchedule = aDecoder.decodeObject(forKey: selectedScheduleKey) as! Schedule
        removedLectures = aDecoder.decodeObject(forKey: removedLecturesKey) as! [Lecture]
        addedLectures = aDecoder.decodeObject(forKey: addedLecturesKey) as! [Lecture]
        oldChanges = aDecoder.decodeObject(forKey: oldChangesKey) as! [ChangedLecture]
        tasks = aDecoder.decodeObject(forKey: tasksKey) as? [Task] ?? []
        calendarIdentifier = aDecoder.decodeObject(forKey: calendarIdentifierKey) as? String
        let loadedfacultyName = aDecoder.decodeObject(forKey:appcolorKey) as? String ?? "default"
        
        switch loadedfacultyName {
        case "economics":
            appColor.faculty = Faculty.economics
        case "computerScience":
            appColor.faculty = Faculty.computerScience
        case "engineeringSciences":
            appColor.faculty = Faculty.engineeringSciences
        default:
            appColor.faculty = Faculty.default
        }

        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(calenderSync, forKey: callenderSyncKey)
        aCoder.encode(selectedSeason, forKey: selectedSeasonKey)
        aCoder.encode(selectedCourses, forKey: selectedCoursesKey)
        aCoder.encode(selectedSemesters, forKey: selectedSemestersKey)
        aCoder.encode(savedSplusnames, forKey: savedSplusnamesKey)
        aCoder.encode(selectedSchedule, forKey: selectedScheduleKey)
        aCoder.encode(removedLectures, forKey: removedLecturesKey)
        aCoder.encode(addedLectures, forKey: addedLecturesKey)
        aCoder.encode(oldChanges, forKey: oldChangesKey)
        aCoder.encode(tasks, forKey: tasksKey)
        aCoder.encode(calendarIdentifier, forKey: calendarIdentifierKey)
        aCoder.encode(appColor.faculty.faculty, forKey: appcolorKey)
    }
}
