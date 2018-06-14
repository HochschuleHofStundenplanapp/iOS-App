//
//  OnboardingTemplate2ViewController.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 20.11.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import UIKit

class OnboardingCourseViewController: UIViewController {
    
    @IBOutlet var courseTableView: UITableView!
    @IBOutlet weak var tutorialDescriptionView: UIView!
    
    var datasource : CourseTableViewDataSource!
    var delegate: CourseTableViewDelegate!
    var courseController: CourseController!
    
    var settingsController: SettingsController!
    
    var tmpSelectedCourses: TmpSelectedCourses!
    var tmpSelectedSemesters: TmpSelectedSemesters!
    var tmpSelectedLectures: TmpSelectedLectures!
    var tmpSelectedSeason: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsController = SettingsController()
        
        let today = Date()
        let currentSemester = today.checkSemester()
        settingsController.tmpSelectedSeason = currentSemester
        
        tmpSelectedCourses = settingsController.tmpSelectedCourses
        tmpSelectedSemesters = settingsController.tmpSelectedSemesters
        tmpSelectedLectures = settingsController.tmpSelectedLectures
        tmpSelectedSeason = settingsController.tmpSelectedSeason
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(showAlert), name: Notification.Name("unreachable"), object: nil)
        
        tutorialDescriptionView.applyShadow()
        
        courseController = CourseController(tmpSelectedCourses: self.tmpSelectedCourses, tmpSelectedSemesters: self.tmpSelectedSemesters, tmpSelectedLectures: self.tmpSelectedLectures, tmpSelectedSeason: tmpSelectedSeason)
        
        datasource = CourseTableViewDataSource(tmpSelectedCourses: tmpSelectedCourses)
        delegate = CourseTableViewDelegate(courseController: courseController)
        
        courseTableView.dataSource = datasource
        courseTableView.delegate = delegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadEnded), name: .coursesDownloadEnded, object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.showNoInternetAlert), name: .coursesDownloadFailed, object: nil )
        
        checkIfCanPassScreen()
    }
    
    @objc func downloadEnded(){
        self.courseTableView.reloadData()
    }
    
    @objc func showNoInternetAlert(){
        let alertController = UIAlertController(title: "Achtung", message:
            "Keine Verbindung zum Internet. Bitte prüfen Sie ihre Internetverbindung.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
        } ))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        courseController.loadAllCourses()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        courseController.cancelLoading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "OnboardingToSemesters"){
            let vc = segue.destination as! OnboardingSemesterViewController
            vc.tmpSelectedCourses = settingsController.tmpSelectedCourses
            vc.tmpSelectedSemesters = settingsController.tmpSelectedSemesters
            vc.tmpSelectedLectures = settingsController.tmpSelectedLectures
            vc.settingsController = settingsController
        }
    }
    
    func checkIfCanPassScreen() {
        if tmpSelectedCourses.numberOfEntries() != 0 {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc
    func showAlert(){
        let alert = UIAlertController(title: "Netzwerkfehler", message: "Server zurzeit nicht erreichbar. Versuchen sie es zu einen späteren Zeitpunkt nochmal", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        present(alert, animated: true) {() -> Void in }
    }
}




