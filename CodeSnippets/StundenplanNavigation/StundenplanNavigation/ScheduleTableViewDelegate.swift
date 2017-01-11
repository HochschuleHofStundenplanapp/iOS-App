//
//  ScheduleTableViewDelegate.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class ScheduleTableViewDelegate: NSObject, UITableViewDelegate {
    
    var selectedIndexPath : IndexPath? = nil
    
    //Hintergrundfarbe jeder 2. Row wird grau
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if(indexPath.row % 2 != 0){
//            cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
//        }
//        else{
//            cell.backgroundColor = UIColor.white
//        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 0.9)
        header.textLabel?.textColor = Constants.HAWRed
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedIndexPath {
        case nil:
            selectedIndexPath = indexPath
        default:
            if(selectedIndexPath! == indexPath){
                selectedIndexPath = nil
            }
            else{
                selectedIndexPath = indexPath
            }
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath
        
        let datasource = tableView.dataSource as! ScheduleTableViewDataSource
        
        if(datasource.isScheduleEmpty() == true){
            return 107
        }
        else{
            let lecture = Settings.sharedInstance.savedSchedule.getLectureAt(section: indexPath.section, row: indexPath.row)
            
            if(selectedIndexPath != nil){
                if index == selectedIndexPath{
                    if(lecture.comment == ""){
                        return 92
                    }
                    else{
                        return 107
                    }
                }
                else{
                    return 58
                }
            }
            else{
                return 58
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //Zeig nur Sections (Wochentag) an, an dem Vorlesungen stattfinden
        let countOfLectures = Settings.sharedInstance.savedSchedule.selectedLectures()
        
        if(countOfLectures[section].count==0){
            return 0
        }
        else{
            return UITableViewAutomaticDimension
        }
    }
}
