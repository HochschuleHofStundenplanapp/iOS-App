//
//  SettingsController.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 03.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class SettingsController: NSObject {
    
   var tmpSelectedLectures: TmpSelectedLectures
    
    init(tmpSelectedLectures: TmpSelectedLectures) {
        
        
        self.tmpSelectedLectures = tmpSelectedLectures
        
    }
    
    // TODO
    public func updateCalendar() {
        _ = CalendarController().CalendarRoutine()
    }
    
    public func clearAllSettings() {
        tmpSelectedLectures.clear()
        // TODO einkommentieren wenn vorhanden
        //TmpSelectedSemesters().clear()
        //TmpSelectedCourses().clear()
    }
}
