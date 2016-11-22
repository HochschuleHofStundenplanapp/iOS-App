//
//  LecturesTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 21.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class LecturesTableViewDataSource: NSObject, UITableViewDataSource {

    var networkController : NetworkController
    let weekdays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"]
    
    init(tableView : UITableView) {
        networkController = NetworkController()
        networkController.loadSchedule(tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "LecturesCell")!
        
        let lecture = Settings.sharedInstance.schedule.getLectureAt(section: indexPath.section, row: indexPath.row)
        
        cell.textLabel?.text = lecture.name
        
        if(Settings.sharedInstance.schedule.isSelected(section: indexPath.section, row: indexPath.row)){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.sharedInstance.schedule.sizeAt(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weekdays.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return weekdays[section]
    }
}
