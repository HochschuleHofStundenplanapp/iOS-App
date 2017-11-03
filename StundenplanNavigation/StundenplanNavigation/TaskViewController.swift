//
//  TaskViewController.swift
//  StundenplanNavigation
//
//  Created by Patrick Niepel on 16.10.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, TaskViewProtocol {
    @IBOutlet weak var taskTableView: UITableView!
    
    var dataSource: TaskTableViewDataSource!
    var delegate: TaskTableViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = TaskTableViewDelegate(viewCtrl: self)
        dataSource = TaskTableViewDataSource()
        taskTableView.dataSource = dataSource
        taskTableView.delegate = delegate

        if #available(iOS 11.0, *) {
            setupNavBar()
        } else {
            // Fallback on earlier versions
        }
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateTaskBadge), name: Notification.Name("completedTaskChanged"), object: nil)
    }
    
    deinit {
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: Notification.Name("completedTaskChanged"), object: nil)
    }
    
    @available(iOS 11.0, *)
    private func setupNavBar() {
         navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TasksToTaskDetail" {
            let destination = segue.destination as! TaskOverviewViewController
            destination.receivedTask = delegate.taskToSend
            destination.receivedSelectedIndexPath = delegate.selectedIndexPath
            destination.receivedViewMode = TaskOverviewViewController.ViewMode.detail
            destination.delegate = self
        } else if segue.identifier == "TasksToAddTask" {
            let destination = segue.destination as! TaskOverviewViewController
            destination.receivedTask = Task()
            destination.delegate = self
            destination.receivedSelectedIndexPath = delegate.selectedIndexPath
            destination.receivedViewMode = TaskOverviewViewController.ViewMode.create
        }
    }

    @IBAction func changeFilterAction(_ sender: UISegmentedControl) {
        dataSource.switchDisplayFilter()
        taskTableView.reloadData()
    }
    
    func receive(editedTaskIndexPath: IndexPath) {
        dataSource.reloadData()
        taskTableView.reloadRows(at: [editedTaskIndexPath], with: .bottom)
    }
    
    func addedNewTask(otherVC: TaskOverviewViewController) {
        otherVC.navigationController?.popViewController(animated: true)
        dataSource.reloadData()
        taskTableView.reloadData()
    }
    
    func changed(filterCriteria: Bool) {
        dataSource.reloadData()
        taskTableView.reloadData()
    }
    
    @objc func updateTaskBadge() {
        DataObjectPersistency().saveDataObject(items: UserData.sharedInstance)
        let taskItemIndex = 2
        let tabBarItem = tabBarController?.tabBar.items![taskItemIndex]
        let numberOfTasks = TaskDisplayController().numberOfNotCompletedTasks()
        if numberOfTasks == 0 {
            tabBarItem?.badgeValue = nil
        } else {
            tabBarItem?.badgeValue = "\(numberOfTasks)"
        }
    }
    
}
