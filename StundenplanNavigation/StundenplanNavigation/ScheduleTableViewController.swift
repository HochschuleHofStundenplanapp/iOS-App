//
//  ScheduleTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {

    @IBOutlet var scheduleTableView: UITableView!
    var datasource : ScheduleTableViewDataSource!
    var delegate: ScheduleTableViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showOnboardingIfNeeded()

        datasource = ScheduleTableViewDataSource()
        delegate = ScheduleTableViewDelegate()
        
        scheduleTableView.dataSource = datasource
        scheduleTableView.delegate = delegate
        
        //Entfernt Seperators von leeren Cells am Ende der Tabelle
        tableView.tableFooterView = UIView(frame: .zero)
        
        if #available(iOS 11.0, *) {
            setUpNavbar()
        } else {
            // Fallback on earlier versions
        }
        
        let taskItemIndex = 2
        let taskNavigationCtrl = tabBarController?.viewControllers?[taskItemIndex] as! UINavigationController
        let taskCtrl = taskNavigationCtrl.childViewControllers[0] as! TaskViewController
        taskCtrl.updateTaskBadge()
    }

    
    @available(iOS 11.0, *)
    func setUpNavbar(){
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SelectedLectures().sortLecturesForSchedule()
        tableView.reloadData()
        
        setUpUI()
    }
    
    func setUpUI() {
        tabBarController?.tabBar.tintColor = appColor.tintColor
        navigationController?.navigationBar.tintColor = appColor.tintColor
    }
    
    func showOnboardingIfNeeded() {
        if UserData.sharedInstance.selectedCourses.isEmpty {
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let onboardingVCtrl = storyboard.instantiateViewController(withIdentifier: OnboardingIDs.onboardingStartID)
            present(onboardingVCtrl, animated: true)
        }
    }
}
