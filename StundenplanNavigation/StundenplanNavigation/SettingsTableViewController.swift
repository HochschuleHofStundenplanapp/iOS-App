//
//  SettingsTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit
import EventKit
import StundenplanFramework

class SettingsTableViewController: UITableViewController, UITabBarControllerDelegate {
    @IBOutlet var saveChangesButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var syncSwitch: UISwitch!
    @IBOutlet weak var facultySegmentControl: UISegmentedControl!
    
    @IBOutlet var courseTableViewCell: UITableViewCell!
    @IBOutlet var semesterTableViewCell: UITableViewCell!
    @IBOutlet var lecturesTableViewCell: UITableViewCell!
    
    @IBOutlet var selectedCoursesLabel: UILabel!
    @IBOutlet var selectedSemesterLabel: UILabel!
    @IBOutlet var selectedLecturesLabel: UILabel!
    
    let backgroundProgressIndicator = ActivityIndicator()
    
    var selectedCoursesString = "..."
    var selectedSemesterString = "..."
    
    var settingsController: SettingsController!
    var navBar = UINavigationBar.appearance()
    let UsrData : UserData = UserData.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.syncSwitch.setOn(UserData.sharedInstance.calenderSync, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCommitedSettings), name: .finishedOnboarding, object: nil)
        
        if #available(iOS 11.0, *) {
            setupNavBar()
        }
        setUpUI()
    }
    
    
    
    @objc func reloadCommitedSettings(){
        settingsController.resetTMPVariables()
        setUpUI()
    }
    
    func setUpUI() {
        segmentControl.tintColor = appColor.tintColor
        saveChangesButton.tintColor = appColor.tintColor
        syncSwitch.onTintColor = appColor.tintColor
        facultySegmentControl.tintColor = appColor.tintColor
        
        tabBarController?.tabBar.tintColor = appColor.tintColor
        navigationController?.navigationBar.barTintColor = appColor.tintColor
        navBar.barTintColor = appColor.tintColor
        
    
        if let navigationController =  tabBarController?.viewControllers?[2] as? UINavigationController {
            if let taskVCtrl = navigationController.viewControllers[0] as? TaskViewController {
                taskVCtrl.updateTaskBadge()
            }
        }
    }
    
    func showOnboardingAgain() {
            settingsController.clearAllSettings()
            UserData.sharedInstance.wipeUserData()
            appColor.faculty = Faculty.default
            UsrData.setSelectedAppColor(newAppColor: "default")
            self.settingsController.stopCalendarSync()
            self.syncSwitch.setOn(false, animated: false)
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let onboardingVCtrl = storyboard.instantiateViewController(withIdentifier: OnboardingIDs.onboardingStartID)
            present(onboardingVCtrl, animated: true)
    }
    
    @available(iOS 11.0, *)
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Updates müssen in viewDidApper, weil erst hier die neue kopier erzeugt wurde (in viewWillApear ist noch die alten Instanz vorhanden)
        updateSeasonSegments()
        disableCellsAndButton()
        selectedCoursesLabel.text = settingsController.tmpSelectedCourses.allSelectedCourses()
        selectedSemesterLabel.text = settingsController.tmpSelectedSemesters.allSelectedSemesters()
        saveChangesButton.setTitle("\(settingsController.countChanges()) Änderungen übernehmen", for: .normal)
        self.syncSwitch.setOn(UserData.sharedInstance.calenderSync, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hanldeCalendarSyncChanged), name: .calendarSyncChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showHasNoAccessAlert), name: .showHasNoAccessAlert, object: nil)
        
        updatePickedColorSegment()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .calendarSyncChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .showHasNoAccessAlert, object: nil)
    }
    
    @IBAction func sectionChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            settingsController.set(season: "SS")
        }else{
            settingsController.set(season: "WS")
        }
        disableCellsAndButton()
        
        selectedCoursesLabel.text = "..."
        selectedSemesterLabel.text = "..."
    }
    
    private func updateSeasonSegments(){
        let today = Date()
        let currentSemester = today.checkSemester()
        
        if (currentSemester == "SS"){
            segmentControl.selectedSegmentIndex = 0
        }else{
            segmentControl.selectedSegmentIndex = 1
        }
        
        settingsController.tmpSelectedSeason = currentSemester
    }
    
    private func updatePickedColorSegment(){
        switch appColor.faculty {
        case Faculty.economics:
            facultySegmentControl.selectedSegmentIndex = 0
        case Faculty.computerScience:
            facultySegmentControl.selectedSegmentIndex = 1
        case Faculty.engineeringSciences:
            facultySegmentControl.selectedSegmentIndex = 2
        default:
            facultySegmentControl.selectedSegmentIndex = 3
            
        }
        
    }
    
    private func disableCellsAndButton(){
        if(settingsController.tmpSelectedCourses.hasSelection()){
            semesterTableViewCell.isUserInteractionEnabled = true
            semesterTableViewCell.textLabel?.isEnabled = true
            semesterTableViewCell.detailTextLabel?.isEnabled = true
            if(settingsController.tmpSelectedSemesters.hasSelection()){
                lecturesTableViewCell.isUserInteractionEnabled = true
                lecturesTableViewCell.textLabel?.isEnabled = true
                lecturesTableViewCell.detailTextLabel?.isEnabled = true
//                saveChangesButton.isEnabled = true
            }
            else{
                lecturesTableViewCell.isUserInteractionEnabled = false
                lecturesTableViewCell.textLabel?.isEnabled = false
                lecturesTableViewCell.detailTextLabel?.isEnabled = false
//                saveChangesButton.isEnabled = false
            }
        }
        else{
            semesterTableViewCell.isUserInteractionEnabled = false
            semesterTableViewCell.textLabel?.isEnabled = false
            semesterTableViewCell.detailTextLabel?.isEnabled = false
            lecturesTableViewCell.isUserInteractionEnabled = false
            lecturesTableViewCell.textLabel?.isEnabled = false
            lecturesTableViewCell.detailTextLabel?.isEnabled = false
//            saveChangesButton.isEnabled = false
        }
    }
    
    @objc func hanldeCalendarSyncChanged() {
        settingsController.handleCalendarSync()
    }
    
    @IBAction func syncSwitchChanged(_ sender: UISwitch) {
        backgroundProgressIndicator.startActivityIndicator(root: self)

        let isSwitchOn = syncSwitch.isOn
        UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        DispatchQueue.global(qos: .background).async {
            if (isSwitchOn) {
                self.settingsController.startCalendarSync()
            } else {
                self.settingsController.stopCalendarSync()
            }
            DispatchQueue.main.async {
                self.backgroundProgressIndicator.stopActivityIndicator()
                UIApplication.shared.endBackgroundTask(UIBackgroundTaskIdentifier())
            }
        }
    }
    
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
        backgroundProgressIndicator.startActivityIndicator(root: self)
        DispatchQueue.global().async {
            self.settingsController.commitChanges()
            DispatchQueue.main.async {
                self.saveChangesButton.setTitle("0 Änderungen übernehmen", for: .normal)
                UIApplication.shared.registerForRemoteNotifications()
                self.backgroundProgressIndicator.stopActivityIndicator()
                
            }
        }
    }
    
    @objc func showHasNoAccessAlert() {
        let alert = UIAlertController(title: "Berechtigungen", message: "Es werden Berechtigungen benötigt um Einträge in den Kalender zu tätigen.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Schließen", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Einstellungen", style: .default, handler: { action in
            let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.open(openSettingsUrl!, options: [:], completionHandler: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SettingsToCourses") {
            
            let vc = segue.destination as! CourseTableViewController
            vc.tmpSelectedCourses = settingsController.tmpSelectedCourses
            vc.tmpSelectedSemesters = settingsController.tmpSelectedSemesters
            vc.tmpSelectedLectures = settingsController.tmpSelectedLectures
            vc.tmpSelectedSeason = settingsController.tmpSelectedSeason
        }else if (segue.identifier == "SettingsToSemesters"){
            
            let vc = segue.destination as! SemesterTableViewController
            vc.tmpSelectedCourses = settingsController.tmpSelectedCourses
            vc.tmpSelectedSemesters = settingsController.tmpSelectedSemesters
            vc.tmpSelectedLectures = settingsController.tmpSelectedLectures
        }else if (segue.identifier == "SettingsToLectures"){
            
            let vc = segue.destination as! LecturesViewController
            vc.tmpSelectedLectures = settingsController.tmpSelectedLectures
            vc.tmpSelectedSemesters = settingsController.tmpSelectedSemesters
            vc.tmpSelectedSeason = settingsController.tmpSelectedSeason
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = tabBarController.selectedIndex
        
        if(index == 3){
            let nc = viewController as! UINavigationController
            let vc = nc.childViewControllers[0] as! SettingsTableViewController
            if vc.settingsController == nil {
                vc.settingsController = SettingsController()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1 && indexPath.row == 0){
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if (indexPath.section == 2 && indexPath.row == 1){
            showOnboardingAgain()
        }
    }
    
    
    
    @IBAction func changeFacultyColor(_ sender: UISegmentedControl) {
        
        /* Ist das Debug Code und kann das weg?
        let task = Task(title: "Task Title :)", dueDate: Date(), taskDescription: "Beschreibung", lecture: "Fortgeschrittene Programmierung unter Swift 3")
        
        CalendarInterface.sharedInstance.addTaskToCalendar(task: task)
        CalendarInterface.sharedInstance.removeTaskFromCalendar(task: task)
 
        */
        switch sender.selectedSegmentIndex {
        case 0:
            appColor.faculty = .economics
            UsrData.setSelectedAppColor(newAppColor: "economics")
        case 1:
            appColor.faculty = .computerScience
            UsrData.setSelectedAppColor(newAppColor: "computerScience")
        case 2:
            appColor.faculty = .engineeringSciences
            UsrData.setSelectedAppColor(newAppColor: "engineeringScience")
        default:
            appColor.faculty = .default
            UsrData.setSelectedAppColor(newAppColor: "default")
        }
        setUpUI()
    }
}
