//
//  UserData.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 27.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class UserData: NSObject {

    var callenderSync: Bool = false
    var selectedSeason : String = "SS"
    var selectedCourses : [Course] = []
    var selectedSemesters : [Semester] = []
    var selectedLectures: [Lecture] = []
    
    static var sharedInstance = UserData()
    private override init(){ }

}
