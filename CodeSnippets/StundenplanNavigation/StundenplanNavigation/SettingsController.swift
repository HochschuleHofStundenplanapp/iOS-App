//
//  SettingsController.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 03.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class SettingsController: NSObject {
    
    public func clearAllSettings() {
        TmpSelectedLectures().clear()
        // TODO einkommentieren wenn vorhanden
        //TmpSelectedSemesters().clear()
        //TmpSelectedCourses().clear()
    }
}
