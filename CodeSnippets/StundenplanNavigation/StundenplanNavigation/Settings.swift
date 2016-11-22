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
    
    var ssws: Season = .summer
    var courses: Courses = Courses()
    var schedule: Schedule = Schedule()
    
    var season: Season {
        get {
            return ssws
        }
        set {
            if(newValue != ssws){
                ssws = newValue
                courses = Courses()
                schedule = Schedule()
            }
        }
    }
}

