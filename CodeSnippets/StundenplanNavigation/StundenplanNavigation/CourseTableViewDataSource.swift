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
    var courses : Courses!
    
    init(tableView : UITableView, ssws: String) {
        networkController = NetworkController()
        courses = Courses()
        networkController.loadCourses(courses: courses, tableView: tableView, ssws: ssws)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell")!
        cell.textLabel?.text = "\(courses.list[indexPath.row].nameDe)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.list.count
    }
}


