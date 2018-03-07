//
//  ScheduleTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit
import StundenplanFramework

class ScheduleTableViewController: UITableViewController {

    @IBOutlet var scheduleTableView: UITableView!
    var datasource : ScheduleTableViewDataSource!
    var delegate: ScheduleTableViewDelegate!
    let usrdata : UserData = UserData.sharedInstance
    
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
        
        //TODO
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
        switch UserData.sharedInstance.getSelectedAppColor() {
        case Faculty.economics.faculty:
            appColor.faculty = Faculty.economics
        case Faculty.computerScience.faculty:
            appColor.faculty = Faculty.computerScience
        case Faculty.engineeringSciences.faculty:
            appColor.faculty = Faculty.engineeringSciences
        default:
            //print("selected appcolor was: " + UserData.sharedInstance.getSelectedAppColor())
            appColor.faculty = Faculty.default
        }
        
        //print("loaded Color", appColor.faculty)

        UINavigationBar.appearance().barTintColor = appColor.tintColor
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
