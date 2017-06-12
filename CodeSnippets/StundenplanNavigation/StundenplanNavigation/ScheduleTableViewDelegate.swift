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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
//        header.contentView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 0.9)
//        header.textLabel?.textColor = UIColor.hawRed
//        header.contentView.backgroundColor = UIColor.hawRed
//        header.contentView.backgroundColor = UIColor(red: 201/255, green: 55/255, blue: 59/255, alpha: 1)
        header.textLabel?.textColor = UIColor.black
//        header.textLabel?.font = header.textLabel?.font.withSize(30)
        header.textLabel?.textAlignment = .center

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath != selectedIndexPath{
            selectedIndexPath = indexPath
        } else {
            selectedIndexPath = nil
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if SelectedLectures().getOneDimensionalList().count > 0 {
            let lecture = SelectedLectures().getElement(at: indexPath)
            
            if(selectedIndexPath != nil){
                if indexPath == selectedIndexPath{
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

        } else {
            return CGFloat(107)
        }
        
    }
}
