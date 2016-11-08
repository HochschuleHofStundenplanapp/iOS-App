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
        
        if(selectedIndexPath != nil){
            if index == selectedIndexPath{
                return 90
            }
            else{
                return 50
            }
        }
        else{
            return 50
        }
    }
}
