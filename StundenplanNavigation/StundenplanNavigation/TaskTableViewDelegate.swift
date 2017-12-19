//
//  TaskTableViewDelegate.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 16.10.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit
import StundenplanFramework
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
        header.backgroundView?.backgroundColor = appColor.headerBackground
        header.textLabel?.textColor = appColor.headerText
    }
}
