//
//  ScheduleTableViewDelegate.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit
import StundenplanFramework

class ScheduleTableViewDelegate: NSObject, UITableViewDelegate {
    
    var selectedIndexPath : IndexPath? = nil
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView

        header.backgroundView?.backgroundColor = appColor.headerBackground
        header.textLabel?.textColor = appColor.headerText
        
        header.textLabel?.textAlignment = .center
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath != selectedIndexPath{
            selectedIndexPath = indexPath
        } else {
            selectedIndexPath = nil
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        //alle cells "schliessen" / Pfeile auf Ausgangsposition (Pfeil der zuletzt geöffneten sonst "offen")
        for cell : UITableViewCell in tableView.visibleCells {
            let _cell = cell as? ScheduleTableViewCell
            _cell?.OpenButton.transform = CGAffineTransform(rotationAngle: 0.0)
            _cell?.setExpandedState(newState: false)
        }

        if let cell : ScheduleTableViewCell = tableView.cellForRow(at: indexPath) as? ScheduleTableViewCell {
            if(indexPath == selectedIndexPath) {
                cell.OpenButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                cell.setExpandedState(newState: true)
            } else {
                cell.OpenButton.transform = CGAffineTransform(rotationAngle: 0.0)
                cell.setExpandedState(newState: false)
            }
        }
        
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var newHeigth : CGFloat = 58
        
        if SelectedLectures().getOneDimensionalList().count > 0 {
            let lecture = SelectedLectures().getElement(at: indexPath)
            
            if(selectedIndexPath != nil){
                if indexPath == selectedIndexPath{
                    if(lecture.comment == ""){newHeigth = 92}
                    else{newHeigth = 107}
                }
                else {newHeigth = 58}
            }
            else{newHeigth = 58}

        } else {newHeigth = 107}
        return newHeigth
    }
}
