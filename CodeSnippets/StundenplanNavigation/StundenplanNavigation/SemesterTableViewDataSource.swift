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
        
        let selectedSem = Settings.sharedInstance.tmpCourses.selectedSemesters()
        
        dump(selectedSem)
        
        cell.textLabel?.text = selectedSem[indexPath.section].list[indexPath.row].name
        
        if(selectedSem[indexPath.section].isSelected(index: indexPath.row)){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.sharedInstance.tmpCourses.selectedSemesters()[section].list.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {        
        return Settings.sharedInstance.tmpCourses.selectedSemesters().count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Settings.sharedInstance.tmpCourses.selectedCoursesName()[section]
    }
}

