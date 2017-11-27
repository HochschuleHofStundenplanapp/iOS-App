//
//  OnboardingSemesterViewController.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 21.11.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import UIKit

class OnboardingSemesterViewController: UIViewController {
    
    @IBOutlet var semesterTableView: UITableView!
    @IBOutlet weak var tutorialDescriptionView: UIView!
    
    var datasource : SemesterTableViewDataSource!
    var delegate: SemesterTableViewDelegate!
    
    var settingsController: SettingsController!
    
    var tmpSelectedCourses: TmpSelectedCourses!
    var tmpSelectedLectures: TmpSelectedLectures!
    var tmpSelectedSemesters: TmpSelectedSemesters!
    
    var semesterController: SemesterController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tutorialDescriptionView.applyShadow()
        
        semesterController = SemesterController(tmpSelectedLectures: tmpSelectedLectures, tmpSelectedSemesters: tmpSelectedSemesters)
        
        datasource = SemesterTableViewDataSource(tmpSelectedCourses: tmpSelectedCourses, tmpSelectedSemesters: tmpSelectedSemesters)
        delegate = SemesterTableViewDelegate(semesterController: semesterController)
        
        semesterTableView.dataSource = datasource
        semesterTableView.delegate = delegate
        
        semesterTableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "OnboardingToLecture"){
            let vc = segue.destination as! OnboardingLecturesViewController
            vc.tmpSelectedLectures = settingsController.tmpSelectedLectures
            vc.tmpSelectedSemesters = settingsController.tmpSelectedSemesters
            vc.tmpSelectedSeason = settingsController.tmpSelectedSeason
            vc.settingsController = settingsController
        }
    }
    
    func checkIfCanPassScreen() {
        if tmpSelectedSemesters.allSemesters().count != 0 {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
}
