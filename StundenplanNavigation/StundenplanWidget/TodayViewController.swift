//
//  TodayViewController.swift
//  StundenplanWidget
//
//  Created by Bastian Kusserow on 27.11.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import UIKit
import NotificationCenter
import StundenplanFramework

class TodayViewController: UIViewController, NCWidgetProviding, TableViewUpdater {
        
    @IBOutlet var changeLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var changesHeightConstraint: NSLayoutConstraint!
 
    var dataSource : WidgetTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        dataSource = WidgetTableViewDataSource()
        dataSource.delegate = self
        tableView.dataSource = dataSource
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        checkIfChangesAreAvailable()
    }
    
    func checkIfChangesAreAvailable(){
        let userData = DataObjectPersistency().loadDataObject()
        let changes = userData.oldChanges
        let calendar = Calendar.current
        
        let todayChanges = changes.filter({calendar.isDateInToday($0.combinedOldDate)})
        if todayChanges.count > 0 {
            changesHeightConstraint.constant = 18
        }else{
            changesHeightConstraint.constant = 0
        }
    }
    
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            preferredContentSize = maxSize
            dataSource.expanded = false
            tableView.reloadData()
        }else{
            dataSource.expanded = true
            tableView.reloadData()
            print(tableView.numberOfSections)
            print(tableView.indexPathsForVisibleRows![0])
            print(tableView.numberOfRows(inSection: 0))
            
            let cell =  tableView.cellForRow(at: tableView.indexPathsForVisibleRows![0])
            print(cell)
            if let cell = cell{
                preferredContentSize = CGSize(width: 0, height: CGFloat(cell.frame.height * 2)+10+changesHeightConstraint.constant)
            }
            
        }
    }
    
    func updateTableView(hide: Bool, timerView: TimerView){
        tableView.reloadData()
        timerView.isHidden = hide
    }
}
