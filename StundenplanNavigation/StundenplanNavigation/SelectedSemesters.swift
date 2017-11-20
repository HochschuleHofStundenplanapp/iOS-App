//
//  SelectedSemesters.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 18.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class SelectedSemesters: NSObject {
    
    fileprivate var userdata = UserData.sharedInstance

    func contains(semester: Semester) -> Bool{
        return userdata.selectedSemesters.contains(semester)
    }
}
