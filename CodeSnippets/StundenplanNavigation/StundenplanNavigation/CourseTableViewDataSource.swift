//
//  CourseTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class CourseTableViewDataSource: NSObject, UITableViewDataSource {
    
    var networkController : NetworkController
    
    init(tableView : UITableView, ssws: String) {
        networkController = NetworkController()
        networkController.loadCourses(tableView: tableView, ssws: ssws)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell")!
        cell.textLabel?.text = "\(Schedule.sharedInstance.courses.getCourseAt(index:indexPath.row).nameDe)"
        
        if(Schedule.sharedInstance.courses.isSelected(index: indexPath.row)){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Schedule.sharedInstance.courses.size()
    }
}


