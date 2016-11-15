//
//  SemesterTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class SemesterTableViewDataSource: NSObject, UITableViewDataSource {
    
    var scheduleSingleton = Schedule.sharedInstance
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SemesterCell")!
        
        let selectedSem = scheduleSingleton.courses.selectedSemesters()
        
        cell.textLabel?.text = selectedSem[indexPath.section].list[indexPath.row].name
        
        if(Schedule.sharedInstance.courses.selectedSemesters()[indexPath.section].isSelected(index: indexPath.row)){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleSingleton.courses.selectedSemesters()[section].list.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return scheduleSingleton.courses.selectedSemesters().count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return scheduleSingleton.courses.selectedCoursesName()[section]
    }
}

