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
    //Alle Veränderunge der Stundenpläne finden hier statt
    //Werden erst übernommen durch Funktion commmitChanges()
    var _tmpSsws: Season = .summer
    var _tmpCourses: Courses = Courses()
    var _tmpSchedule: Schedule = Schedule()
    
    //Gespeicherte Daten
    var _savedSsws: Season = .summer
    var _savedCourses: Courses = Courses()
    var _savedSchedule: Schedule = Schedule()
    
    
    //Daten von tmp zu saved umändern
    
    var savedSeason: Season {
        get {
            //return _savedSsws
            return _tmpSsws
        }
        set {
//            if(newValue != _savedSsws){
//                _savedSsws = newValue
//                _savedCourses = Courses()
//                _savedSchedule = Schedule()
//            }
            if(newValue != _tmpSsws){
                _tmpSsws = newValue
                _tmpCourses = Courses()
                _tmpSchedule = Schedule()
            }
        }
    }
    
    var savedCourses: Courses{
        get{
            //return _savedCourses
            return _tmpCourses
        }
    }
    
    var savedSchedule: Schedule{
        get{
            //return _savedSchedule
            return _tmpSchedule
        }
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
    
    func copyData(){
        
    }
    
    func countChanges() -> Int{
        //Anzahl der Änderungen berechnen
        return 1
    }
    
    func commitChanges() {
        //Änderungen im Settings Screen übernehmen
    }
}

