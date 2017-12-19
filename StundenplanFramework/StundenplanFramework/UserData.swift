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
public class UserData: NSObject, NSCoding{

    public static var sharedInstance = UserData()
    
    public var calenderSync: Bool = false
    public var selectedSeason : String = Date().checkSemester()
    public var selectedCourses : [Course] = []
    public var selectedSemesters : [Semester] = []
    public var savedSplusnames : [String] = [String]()//Auslagern
    public var selectedSchedule: Schedule = Schedule()
    public var oldChanges : [ChangedLecture] = []
    public var tasks: [Task] = []
    
    public var calendarIdentifier: String?
    
    public var removedLectures: [Lecture] = []
    public var addedLectures: [Lecture] = []
    
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

    private override init(){}
    
    override public func copy() -> Any {
        let copy = UserData()
        copy.selectedSeason = selectedSeason
        copy.selectedCourses = selectedCourses
        copy.selectedSemesters = selectedSemesters
        copy.selectedSchedule = selectedSchedule.copy() as! Schedule
        
        copy.removedLectures = removedLectures
        copy.addedLectures = addedLectures
        copy.calenderSync = calenderSync
        copy.tasks = tasks
        return copy
    }
    
    public func wipeUserData(){
        //        calenderSync = false
        selectedSeason = Date().checkSemester()
        selectedCourses = []
        selectedSemesters = []
        savedSplusnames = [String]()//Auslagern
        selectedSchedule = Schedule()
        oldChanges = []
    }
    
    required public init?(coder aDecoder: NSCoder) {
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

        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
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
        
    }
}
