//
//  LecturesTableViewDelegate.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 21.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class LecturesTableViewDelegate: NSObject, UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        Settings.sharedInstance.schedule.toggleLectureAt(section: indexPath.section, row: indexPath.row)
        
        tableView.reloadData()
    }
}
