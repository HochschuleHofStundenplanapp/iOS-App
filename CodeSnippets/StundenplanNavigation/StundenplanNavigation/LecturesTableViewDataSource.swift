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
    
    init(tableView : UITableView) {
        networkController = NetworkController()
        
        let season = Settings.sharedInstance.season.rawValue
        let semester =
        
        networkController.loadSchedule(tableView: tableView, season: season, semester: <#T##String#>, course: <#T##String#>)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LecturesCell")!
        
        cell.textLabel?.text = Settings.sharedInstance.schedule.list[indexPath.row].name
        
        if(Settings.sharedInstance.courses.selectedSemesters()[indexPath.section].isSelected(index: indexPath.row)){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.sharedInstance.schedule.size()
    }
    
}
