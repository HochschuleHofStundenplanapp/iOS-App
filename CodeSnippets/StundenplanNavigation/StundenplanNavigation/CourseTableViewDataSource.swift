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
    
    init(tableView : CourseTableViewController, ssws: String) {
        networkController = NetworkController()
        networkController.loadCourses(tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell")!
        cell.textLabel?.text = "\(Settings.sharedInstance.tmpCourses.getCourseAt(index:indexPath.row).nameDe)"
        
        if(Settings.sharedInstance.tmpCourses.isSelected(index: indexPath.row)){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.sharedInstance.tmpCourses.size()
    }
}


