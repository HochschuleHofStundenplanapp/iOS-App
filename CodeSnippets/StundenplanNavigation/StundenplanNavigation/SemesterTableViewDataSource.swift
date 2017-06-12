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
        
        let semester = TmpSelectedSemesters().semester(at: indexPath)
        
        cell.textLabel?.text = semester.name
        
        if SelectedSemesters().contains(semester: semester) {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TmpSelectedSemesters().numberOfEntries(for: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TmpSelectedCourses().numberOfEntries()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TmpSelectedCourses().courseName(at: section)
    }
}

