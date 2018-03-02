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
        tableView.delegate = dataSource
        
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
            
            let cell =  tableView.cellForRow(at: tableView.indexPathsForVisibleRows![0])

            if let cell = cell{
                var count = CGFloat(dataSource.lectureCtrl.resultLectures.count)
                if(count > 4) {
                    count = 4
                }
                preferredContentSize = CGSize(width: 0, height: CGFloat(cell.frame.height * count)+10+changesHeightConstraint.constant)
            }
            
        }
    }
    
    
    func updateTableView(hide: Bool, timerView: TimerView){
        tableView.reloadData()
        timerView.isHidden = hide
    }
}
