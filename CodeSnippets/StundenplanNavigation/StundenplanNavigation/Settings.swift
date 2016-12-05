//
//  Settings.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 21.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

enum Season : String {
    case summer = "SS"
    case winter = "WS"
}

class Settings: NSObject {

    static let sharedInstance = Settings()
    private override init(){}
    
    //Temporäre Daten
    var _tmpSsws: Season = .summer
    var _tmpCourses: Courses = Courses()
    var _tmpSchedule: Schedule = Schedule()
    
    //Gespeicherte Daten
    var _savedSsws: Season = .summer
    var _savedCourses: Courses = Courses()
    var _savedSchedule: Schedule = Schedule()
        
    var savedSchedule: Schedule{
            return _savedSchedule
//            return _tmpSchedule
    }
    
    var tmpSeason: Season {
        get {
            return _tmpSsws
        }
        set {
            if(newValue != _tmpSsws){
                _tmpSsws = newValue
                _tmpCourses = Courses()
                _tmpSchedule = Schedule()
            }
        }
    }
    
    var tmpCourses: Courses{
        get{
            return _tmpCourses
        }
    }
    
    var tmpSchedule: Schedule{
        get{
            return _tmpSchedule
        }
    }
    
    //Daten aus saved in tmp laden
    func copyData(){
        _tmpSsws = _savedSsws
        _tmpCourses = _savedCourses.copy() as! Courses
        _tmpSchedule = _savedSchedule.copy() as! Schedule
    }
    
    //Daten von tmp in saved übernehmen
    func commitChanges() {
        print("commit")
        _savedSsws = _tmpSsws
        _savedCourses = _tmpCourses.copy() as! Courses
        _savedSchedule = _tmpSchedule.copy() as! Schedule
    }
    
    func countChanges() -> Int{

        return 1
    }
}

