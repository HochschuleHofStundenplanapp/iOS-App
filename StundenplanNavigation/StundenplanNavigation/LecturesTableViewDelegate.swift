//
//  LecturesTableViewDelegate.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 21.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class LecturesTableViewDelegate: NSObject, UITableViewDelegate {
    
    let lectureController: LectureController
    
    init(lectureController: LectureController){
        self.lectureController = lectureController
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
////        header.contentView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 0.9)
////        header.textLabel?.textColor = UIColor.hawBlue
//        header.textLabel?.textAlignment = .center
//    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = appColor.headerText
//            headerTitle.contentView.backgroundColor = appColor.headerText
            headerTitle.textLabel?.textAlignment = .center
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("func tableView(_ tableView: UITableView, didSelectRowAt indexPath: \(indexPath)")
        lectureController.toggleLecture(at: indexPath)
        tableView.reloadData()
        
        if let onboardingViewController = tableView.parentViewController as? OnboardingLecturesViewController {
            onboardingViewController.checkIfCanPassScreen()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 73
    }
    

    
}
