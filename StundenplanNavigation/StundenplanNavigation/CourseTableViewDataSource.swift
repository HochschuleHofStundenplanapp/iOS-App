//
//  CourseTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class CourseTableViewDataSource: NSObject, UITableViewDataSource {
    
    var tmpSelectedCourses : TmpSelectedCourses
    
    init (tmpSelectedCourses: TmpSelectedCourses){
        self.tmpSelectedCourses = tmpSelectedCourses
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell")!
        
        let course = AllCourses().course(at: indexPath)
        
        cell.textLabel?.text = "\(course.nameDe)"
        
        if tmpSelectedCourses.contains(course: course) {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllCourses().numberOfEntries()
    }
}


