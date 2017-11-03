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

        header.textLabel?.textColor = UIColor.black
        header.textLabel?.textAlignment = .center
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
 //       if !cell.isExpanded {
  //          cell.isExpanded = true
  //      }
//        else{
 //           cell.isExpanded = false
  //x      }
        
        if indexPath != selectedIndexPath{
            selectedIndexPath = indexPath
        } else {
            selectedIndexPath = nil
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)

          //rotate Aufklapp-Pfeil
        let cell : ScheduleTableViewCell = tableView.cellForRow(at: indexPath) as! ScheduleTableViewCell!
        
        if(indexPath == selectedIndexPath) {
           cell.OpenButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            print("Cell rotation for \(indexPath)")
        } else {
            cell.OpenButton.transform = CGAffineTransform(rotationAngle: 0.0)
        }
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
