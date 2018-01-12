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
        
        courseController.toggleCourse(at: getRowInTableView(indexPath: indexPath, tableView: tableView))
        tableView.reloadData()
        
        if let onboardingViewController = tableView.parentViewController as? OnboardingCourseViewController {
            onboardingViewController.checkIfCanPassScreen()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = appColor.headerText
//            headerTitle.contentView.backgroundColor = appColor.headerText
        }
    }
    
    fileprivate func getRowInTableView(indexPath: IndexPath, tableView:UITableView) -> Int{
        var total = 0
        for i in 0..<indexPath.section{
            let rows = tableView.numberOfRows(inSection: i)
            total+=rows
        }
        
        total+=indexPath.row
        
        return total
    }
    
}












