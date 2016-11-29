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
    var tmpSsws: Season = .summer
    var tmpCourses: Courses = Courses()
    var tmpSchedule: Schedule = Schedule()
    
    //Gespeicherte Daten
    var savedSsws: Season = .summer
    var savedCourses: Courses = Courses()
    var savedSchedule: Schedule = Schedule()
    
    var season: Season {
        get {
            let tmp = Season(rawValue: savedSsws.rawValue)
            return tmp!
        }
        set {
            if(newValue != tmpSsws){
                tmpSsws = newValue
                tmpCourses = Courses()
                tmpSchedule = Schedule()
            }
        }
    }
    
    var courses: Courses{
        get{
            tmpCourses = savedCourses.copy() as! Courses
            return tmpCourses
        }
    }
    
    var schedule: Schedule{
        get{
            tmpSchedule = savedSchedule.copy() as! Schedule
            return tmpSchedule
        }
    }
    
    func countChanges() -> Int{
        //Anzahl der Änderungen berechnen
        return 1
    }
    
    func commitChanges() {
        //Änderungen im Settings Screen übernehmen
    }
}

