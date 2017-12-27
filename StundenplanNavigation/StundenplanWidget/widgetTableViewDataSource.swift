//
//  widgetTableViewDataSource.swift
//  StundenplanWidget
//
//  Created by Bastian Kusserow on 30.11.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import UIKit
import StundenplanFramework

class WidgetTableViewDataSource: NSObject, UITableViewDataSource {
    
    let lectureCtrl = WidgetLectureController()
    var expanded = false
    var delegate : TableViewUpdater!
    var firstIsNext = false
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetCell") as! WidgetCell
        let (lecture, day) = lectureCtrl.getAllLecture()[indexPath.row]
        cell.delegate = delegate
        
        
        cell.setLecture(lecture: (lecture,day))
        
        // Kann man sicher besser machen
        if indexPath.row == 0 && cell.nowOutlet.text == "Nächste" {
            firstIsNext = true
        }else if indexPath.row == 1 && firstIsNext && cell.nowOutlet.text == "Nächste"{
            cell.nowOutlet.text = "Übernächste"
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

