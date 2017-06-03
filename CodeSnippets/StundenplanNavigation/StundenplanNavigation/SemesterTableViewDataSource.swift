//
//  SemesterTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class SemesterTableViewDataSource: NSObject, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SemesterCell")!
        
        cell.textLabel?.text = UserData.sharedInstance.semester(at: indexPath).name
        
        let semester = UserData.sharedInstance.semester(at: indexPath)
        
        if UserData.sharedInstance.selectedSemesters.contains(semester) {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserData.sharedInstance.semesterSize(at: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SelectedCourses().numberOfEntries()
//        return UserData.sharedInstance.coursesSize()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SelectedCourses().courseName(at: section)
//        return UserData.sharedInstance.courseName(at: section)
    }
}

