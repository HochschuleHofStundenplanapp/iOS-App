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
        
        if(Settings.sharedInstance.tmpSchedule.isAllSelected()){
            mainViewController.switchSelectAllButtonIcon(iconName: "Kreuz")
        }
        else{
            mainViewController.switchSelectAllButtonIcon(iconName: "Haken")
        }
        
//        if(Settings.sharedInstance.tmpSchedule.isToggled(section: indexPath.section, row: indexPath.row)){
//            mainViewController.switchSelectAllButtonIcon(iconName: "Kreuz")
//        }
//        else{
//            
//        }
        
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
        var everythingSelected = true
        
        for i in list{
            for j in i{
                if(j.selected == false){
                    everythingSelected = false
                }
            }
        }
        
        if(!everythingSelected){
            for i in list{
                for j in i{
                    j.selected = true
                }
            }
            mainViewController.switchSelectAllButtonIcon(iconName: "Kreuz")
            everythingSelected = true
        }
        else{
            for i in list{
                for j in i{
                    j.selected = false
                }
            }
            mainViewController.switchSelectAllButtonIcon(iconName: "Haken")
        }
        tableView.reloadData()
    }
}
