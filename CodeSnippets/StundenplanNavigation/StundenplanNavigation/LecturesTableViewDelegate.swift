//
//  LecturesTableViewDelegate.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 21.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class LecturesTableViewDelegate: NSObject, UITableViewDelegate {
    var mainViewController : LecturesTableViewController!
    
    init(ctrl : LecturesTableViewController) {
        mainViewController = ctrl
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 0.9)
        header.textLabel?.textColor = Constants.HAWBlue
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        Settings.sharedInstance.tmpSchedule.toggleLectureAt(section: indexPath.section, row: indexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        let lecture = Settings.sharedInstance.tmpSchedule.getLectureAt(section: indexPath.section, row: indexPath.row)
        
        if(lecture.comment != ""){
            return 73
        }
        else{
            return 58
        }
    }
    
    func selectAllCells(tableView: UITableView){
        let list = Settings.sharedInstance.tmpSchedule.list
        
        for i in list{
            for j in i{
                j.selected = true
            }
        }
        tableView.reloadData()
    }
    
    func deSelectAllCells(tableView: UITableView){
        let list = Settings.sharedInstance.tmpSchedule.list
        
        for i in list{
            for j in i{
                j.selected = false
            }
        }
        tableView.reloadData()
    }
}
