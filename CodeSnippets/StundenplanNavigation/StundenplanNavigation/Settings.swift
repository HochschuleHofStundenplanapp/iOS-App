//
//  Settings.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 21.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit



class Settings: NSObject, NSCoding {

    dynamic var status: Status = .DataLoaded
    
    let ssWsKey = "settings_SavedSsws"
    let savedCoursesKey = "settings_SavedCourses"
    let savedScheduleKey = "settings_SavedSchedule"
    let savedCalSyncKey = "settings_SavedCalSync"
    
    static var sharedInstance = Settings()
    private override init(){}
    
    required init?(coder aDecoder: NSCoder) {
        savedSsws = Season.init(term: aDecoder.decodeObject(forKey: ssWsKey) as! String)!
        savedCourses = aDecoder.decodeObject(forKey: savedCoursesKey) as! Courses
        savedSchedule = aDecoder.decodeObject(forKey: savedScheduleKey) as! Schedule
        savedCalSync = aDecoder.decodeBool(forKey: savedCalSyncKey)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(savedSsws.rawValue, forKey: ssWsKey)
        aCoder.encode(savedCourses, forKey: savedCoursesKey)
        aCoder.encode(savedSchedule, forKey:savedScheduleKey)
        aCoder.encode(savedCalSync, forKey: savedCalSyncKey)
    }
    
    //Temporäre Daten
    private var _tmpSsws: Season = .Summer
    var tmpCourses: Courses = Courses()
    var tmpSchedule: Schedule = Schedule()
    
    //Gespeicherte Daten
    var savedSsws: Season = .Summer
    var savedCourses: Courses = Courses()
    var savedSchedule: Schedule = Schedule()
    var savedChanges: Changes = Changes()
    var savedCalSync: Bool = false
    
    var tmpSeason: Season {
        get {
            return _tmpSsws
        }
        set {
            if(newValue != _tmpSsws){
                _tmpSsws = newValue
                tmpCourses = Courses()
                tmpSchedule = Schedule()
            }
        }
    }
    
    func setTmpCourses(courses : [Course]){
        let newCourses = Courses(courses: courses)
        newCourses.setSelektion(courses: tmpCourses)
        self.tmpCourses = newCourses
    }
    
    //Vergleich der gewählten Vorlesungen mit Änderungen
    func compareScheduleAndChanges(){
        savedSchedule.extractSelectedLectures()
        let newSavedChanges = Changes()
        for changedLecture in savedChanges.changes{
            for lecture in savedSchedule.selLectures{
                if compareChangesAndLectures(lecture: lecture, chLecture: changedLecture){
                    newSavedChanges.addChanges(cl: [changedLecture])
                }
            }
        }
        savedChanges.changes.removeAll()
        savedChanges.addChanges(cl: newSavedChanges.changes)
    }
    
    private func compareChangesAndLectures(lecture : Lecture, chLecture : ChangedLecture) -> Bool {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let oldTime = timeFormatter.string(from: lecture.starttime)
        let newChangedTime = timeFormatter.string(from: chLecture.oldTime)
        
        return (lecture.name == chLecture.name) && (lecture.room == chLecture.oldRoom) && (lecture.day == chLecture.oldDay) && (oldTime == newChangedTime) && (lecture.course.contraction == chLecture.course.contraction) && (lecture.group == chLecture.group)
    }
    
    //Daten aus saved in tmp laden
    func copyData(){
        _tmpSsws = savedSsws
        tmpCourses = savedCourses.copy() as! Courses
        tmpSchedule = savedSchedule.copy() as! Schedule
    }
    
    //Daten von tmp in saved übernehmen
    func commitChanges() {
        savedSsws = _tmpSsws
        savedCourses = tmpCourses.copy() as! Courses
        savedSchedule = tmpSchedule.copy() as! Schedule
    }
    
    func countChanges() -> Int{
        let deleted = tmpSchedule.removedLectures(oldSchedule: savedSchedule).count
        let added = tmpSchedule.addedLectures(oldSchedule: savedSchedule).count
        return added + deleted
    }
}

