//
//  SemesterTableViewDelegate.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class SemesterTableViewDelegate: NSObject, UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
//        Schedule.sharedInstance.courses.[indexPath.section].toggleSemesterAt(index: indexPath.row)
        
        Schedule.sharedInstance.courses.selectedCourses()[indexPath.section].semesters.toggleSemesterAt(index: indexPath.row)
        
        tableView.reloadData()
        //        dump(Courses.sharedInstance.selectedCourses())
    }
}
