//
//  SemesterTableViewDelegate.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class SemesterTableViewDelegate: NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 0.9)
        header.textLabel?.textColor = UIColor(red: 0.0039, green: 0.4078, blue: 0.6824, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Settings.sharedInstance.tmpCourses.selectedCourses()[indexPath.section].semesters.toggleSemesterAt(index: indexPath.row)
        
        tableView.reloadData()
        
    }
}
