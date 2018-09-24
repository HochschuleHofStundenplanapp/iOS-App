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
        
        //changes for today
        //let todayChanges = changes.filter({calendar.isDateInToday($0.combinedOldDate)})

        //Test all changes in future
        let todayChanges = changes.filter({($0.combinedOldDate > Date())
                            ||
                        ( (nil != $0.combinedNewDate) && ($0.combinedNewDate > Date()) )
        })
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
        checkIfChangesAreAvailable()
        if activeDisplayMode == .compact {
            preferredContentSize = maxSize
            dataSource.expanded = false
            tableView.reloadData()
        }else{
            //let cell =  tableView.cellForRow(at: tableView.indexPathsForVisibleRows![0])
            dataSource.expanded = true
            tableView.reloadData()

            if let row = tableView.indexPathsForVisibleRows, let first = row.first{
                if let cell = tableView.cellForRow(at: first) {
                    var count = CGFloat(dataSource.lectureCtrl.resultLectures.count)
                    if(count > 4) {
                        count = 4
                    }
                    preferredContentSize = CGSize(width: 0, height: CGFloat((cell.frame.height) * count)+10+changesHeightConstraint.constant)
                }
            }
            else {
//                var count = CGFloat(dataSource.lectureCtrl.resultLectures.count)
//                if(count > 4) {
//                    count = 4
//                }
//                preferredContentSize = CGSize(width: 0, height: CGFloat(50 * count))
                print("error calculate preferredContentSize")
            }
            
        }
    }
    
    
    func updateTableView(hide: Bool, timerView: TimerView){
        tableView.reloadData()
        timerView.isHidden = hide
    }
}
