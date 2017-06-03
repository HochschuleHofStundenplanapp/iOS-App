//
//  CourseTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class CourseTableViewDataSource: NSObject, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell")!
        
        let course = ServerData.sharedInstance.course(at: indexPath)
        
        cell.textLabel?.text = "\(course.nameDe)"
        
        if SelectedCourses().contains(course: course) {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ServerData.sharedInstance.allCourses.count
    }
}


