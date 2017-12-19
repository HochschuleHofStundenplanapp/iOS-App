//
//  TaskTableViewDataSource.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 16.10.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit
import StundenplanFramework
class TaskTableViewDataSource: NSObject, UITableViewDataSource {
    private let taskDisplayCtrl = TaskDisplayController(sortMode: .date)
    
    // DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskDisplayCtrl.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskDisplayCtrl.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return taskDisplayCtrl.sectionHeaderTitle(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskDisplayCtrl.task(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITaskTableViewCell
        cell.display(task: task, for: taskDisplayCtrl.sortMode, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = getTask(for: indexPath)
            CalendarInterface.sharedInstance.removeTaskFromCalendar(task: taskToDelete)
            taskDisplayCtrl.delete(at: indexPath)
            if taskDisplayCtrl.numberOfRows(in: indexPath.section) == 0 {
                taskDisplayCtrl.deleteSection(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .left)
            } else {
                tableView.deleteRows(at: [indexPath], with: .left)
            }
        }
    }
    
    // Helper Methods
    func switchDisplayFilter() {
        switch taskDisplayCtrl.sortMode {
        case .date: taskDisplayCtrl.switchSortMode(to: .lecture)
        case .lecture: taskDisplayCtrl.switchSortMode(to: .date)
        }
    }
    
    func reloadData() {
        taskDisplayCtrl.reloadData()
    }
    
    func getTask(for indexPath: IndexPath) -> Task {
        return taskDisplayCtrl.task(at: indexPath)
    }
}
