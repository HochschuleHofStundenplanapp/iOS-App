//
//  LecturesTableViewDelegate.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 21.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class LecturesTableViewDelegate: NSObject, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 0.9)
        header.textLabel?.textColor = UIColor(red: 0.0039, green: 0.4078, blue: 0.6824, alpha: 1.0)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        Settings.sharedInstance.schedule.toggleLectureAt(section: indexPath.section, row: indexPath.row)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        let lecture = Settings.sharedInstance.schedule.getLectureAt(section: indexPath.section, row: indexPath.row)
        
        if(lecture.comment != ""){
            return 73
        }
        else{
            return 58
        }
    }
}
