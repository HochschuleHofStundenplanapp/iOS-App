//
//  ServerData.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 26.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit
/**
 Speichert die vom Server kommenden Infos über die 
 * angebotenen Studiengänge und Semester -> allCourses
 * Vorlesungen der ausgewählten Studiengänge -> schedule
 */

class ServerData: NSObject {

    var allCourses : [Course] = []
    var allChanges : [ChangedLecture] = []
    var lastAllChanges : [ChangedLecture] = []
    var schedule: Schedule = Schedule()
        
    static var sharedInstance = ServerData()
    private override init(){ }
}
