//
//  SemesterTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class SemesterTableViewDataSource: NSObject, UITableViewDataSource {
    
    
    
    var tmpSelectedCourses : TmpSelectedCourses
    var tmpSelectedSemesters : TmpSelectedSemesters
   
    init (tmpSelectedCourses: TmpSelectedCourses, tmpSelectedSemesters: TmpSelectedSemesters)
    {
        self.tmpSelectedCourses = tmpSelectedCourses
        self.tmpSelectedSemesters = tmpSelectedSemesters
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SemesterCell")!
        
        let semester = tmpSelectedSemesters.semester(at: indexPath)
        
        cell.textLabel?.text = semester.name
        
        if SelectedSemesters().contains(semester: semester) {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmpSelectedSemesters.numberOfEntries(for: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tmpSelectedCourses.numberOfEntries()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tmpSelectedCourses.courseName(at: section)
    }
}

