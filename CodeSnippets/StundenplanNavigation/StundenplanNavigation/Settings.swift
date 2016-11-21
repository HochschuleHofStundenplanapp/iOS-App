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
    
    var season: Season = .summer
    var courses: Courses = Courses()
//    var semesters: Semesters = Semesters()    Steht in Course
    var schedule: Schedule = Schedule()
}

