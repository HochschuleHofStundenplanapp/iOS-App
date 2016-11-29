//
//  CourseTableViewDelegate.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class CourseTableViewDelegate: NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        Settings.sharedInstance.tmpCourses.toggleCourseAt(index: indexPath.row)
        tableView.reloadData()
    }
}
