//
//  TaskTableViewDelegate.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 16.10.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class TaskTableViewDelegate: NSObject, UITableViewDelegate {
    weak var viewCtrl: UIViewController?
    var taskToSend: Task!
    var selectedIndexPath: IndexPath!
    
    init(viewCtrl: UIViewController) {
        self.viewCtrl = viewCtrl
    }
    
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dSource = tableView.dataSource as! TaskTableViewDataSource
        let task = dSource.getTask(for: indexPath)
        taskToSend = task
        selectedIndexPath = indexPath
        viewCtrl?.performSegue(withIdentifier: "TasksToTaskDetail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = getLectureColor(for: section)
    }
    
    // Helper Methods
    func getLectureColor(for section: Int) -> UIColor {
        switch section {
        case 0: return UIColor(red: 70.0/255.0, green: 167.0/255.0, blue: 98.0/255.0, alpha: 1.0)
        case 1: return UIColor(red: 100.0/255.0, green: 188.0/255.0, blue: 112.0/255.0, alpha: 1.0)
        case 2: return UIColor(red: 41.0/255.0, green: 187.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        case 3: return UIColor(red: 88.0/255.0, green: 173.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        case 4: return UIColor(red: 65.0/255.0, green: 143.0/255.0, blue: 183.0/255.0, alpha: 1.0)
        default: return UIColor.darkGray
        }
    }
}
