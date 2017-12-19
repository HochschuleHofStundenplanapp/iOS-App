//
//  widgetTableViewDataSource.swift
//  StundenplanWidget
//
//  Created by Bastian Kusserow on 30.11.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import UIKit
import StundenplanFramework

class widgetTableViewDataSource: NSObject, UITableViewDataSource {
    
    let lectureCtrl = WidgetLectureController()
    var expanded = false
    var delegate : TableViewUpdater!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetCell") as! WidgetCell
        let lecture = lectureCtrl.getAllLecture()[indexPath.row]
        cell.delegate = delegate
        
        if indexPath.row == 0 {
            cell.setLecture(lecture: lecture, now: "Jetzt")
        }else{
           cell.setLecture(lecture: lecture, now: "Nächste")
            cell.timerView.isHidden = true
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expanded {
            return 2
        }else{
            return 1
        }
    }
}
