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
    
    var callenderSync: Bool = false
    var selectedSeason : String = Date().checkSemester()
    var selectedCourses : [Course] = []
    var selectedSemesters : [Semester] = []
    var savedSplusnames : [String] = [String]()//Auslagern
    var selectedSchedule: Schedule = Schedule()
    var oldChanges : [ChangedLecture] = []
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
    let calendarIdentifierKey = "calendarIdentifier"

    private override init(){}
    
    override func copy() -> Any {
        let copy = UserData()
        copy.selectedSeason = selectedSeason
        copy.selectedCourses = selectedCourses
        copy.selectedSemesters = selectedSemesters
        copy.selectedSchedule = selectedSchedule.copy() as! Schedule
        
        copy.removedLectures = removedLectures
        copy.addedLectures = addedLectures
        copy.callenderSync = callenderSync

        copy.calendarIdentifier = calendarIdentifier
        return copy
    }
    
    required init?(coder aDecoder: NSCoder) {
        callenderSync = aDecoder.decodeBool(forKey: callenderSyncKey)
        selectedSeason = aDecoder.decodeObject(forKey: selectedSeasonKey) as! String
        selectedCourses = aDecoder.decodeObject(forKey: selectedCoursesKey) as! [Course]
        selectedSemesters = aDecoder.decodeObject(forKey: selectedSemestersKey) as! [Semester]
        savedSplusnames = aDecoder.decodeObject(forKey: savedSplusnamesKey) as! [String]
        selectedSchedule = aDecoder.decodeObject(forKey: selectedScheduleKey) as! Schedule
        removedLectures = aDecoder.decodeObject(forKey: removedLecturesKey) as! [Lecture]
        addedLectures = aDecoder.decodeObject(forKey: addedLecturesKey) as! [Lecture]
        oldChanges = aDecoder.decodeObject(forKey: oldChangesKey) as! [ChangedLecture]
        
        if let calIdent = aDecoder.decodeObject(forKey: calendarIdentifierKey) {
            calendarIdentifier = calIdent as! String
        } else {
            print("calendar ident is nil")
        }

        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(callenderSync, forKey: callenderSyncKey)
        aCoder.encode(selectedSeason, forKey: selectedSeasonKey)
        aCoder.encode(selectedCourses, forKey: selectedCoursesKey)
        aCoder.encode(selectedSemesters, forKey: selectedSemestersKey)
        aCoder.encode(savedSplusnames, forKey: savedSplusnamesKey)
        aCoder.encode(selectedSchedule, forKey: selectedScheduleKey)
        aCoder.encode(removedLectures, forKey: removedLecturesKey)
        aCoder.encode(addedLectures, forKey: addedLecturesKey)
        aCoder.encode(oldChanges, forKey: oldChangesKey)
        aCoder.encode(calendarIdentifier, forKey: calendarIdentifierKey)
        
    }
}

