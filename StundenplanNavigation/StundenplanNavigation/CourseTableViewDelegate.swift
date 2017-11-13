//
//  CourseTableViewDelegate.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class CourseTableViewDelegate: NSObject, UITableViewDelegate {
    
    var courseController: CourseController
    
    init(courseController: CourseController)
    {
        self.courseController = courseController
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         courseController.toggleCourse(at: indexPath)
        tableView.reloadData()
    }
}
