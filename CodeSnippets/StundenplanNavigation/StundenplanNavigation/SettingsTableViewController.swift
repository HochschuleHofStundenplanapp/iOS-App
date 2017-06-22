//
//  SettingsTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit
import EventKit

class SettingsTableViewController: UITableViewController, UITabBarControllerDelegate {
    @IBOutlet var saveChangesButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var syncSwitch: UISwitch!
    
    @IBOutlet var courseTableViewCell: UITableViewCell!
    @IBOutlet var semesterTableViewCell: UITableViewCell!
    @IBOutlet var lecturesTableViewCell: UITableViewCell!
    
    @IBOutlet var selectedCoursesLabel: UILabel!
    @IBOutlet var selectedSemesterLabel: UILabel!
    @IBOutlet var selectedLecturesLabel: UILabel!
    
    var selectedCoursesString = "..."
    var selectedSemesterString = "..."
    
    var settingsController: SettingsController!
    
    var oldTabIndex = 0
//    var tmpSelectedCourses: TmpSelectedCourses!
//    var tmpSelectedSemesters: TmpSelectedSemesters!
//    var tmpSelectedLectures: TmpSelectedLectures!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedLecturesLabel.text = ""
        
//        tmpSelectedCourses = TmpSelectedCourses()
//        tmpSelectedSemesters = TmpSelectedSemesters()
//        tmpSelectedLectures = TmpSelectedLectures()
        settingsController = SettingsController()
//        tmpSelectedCourses = TmpSelectedCourses()
//        tmpSelectedSemesters = TmpSelectedSemesters()
//        tmpSelectedLectures = TmpSelectedLectures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        saveChangesButton.setTitle(Constants.changesButtonTitle, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.tintColor = UIColor.hawBlue
        
        selectedCoursesLabel.text = settingsController.tmpSelectedCourses.allSelectedCourses()
        selectedSemesterLabel.text = settingsController.tmpSelectedSemesters.allSelectedSemesters()
        
        NotificationCenter.default.addObserver(self, selector: #selector(hanldeCalendarSyncChanged), name: .calendarSyncChanged, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        NotificationCenter.default.removeObserver(self, name: .calendarSyncChanged, object: nil)
    }
    
    @IBAction func sectionChanged(_ sender: UISegmentedControl) {
        //Auslagern in eigenen Controller
//        if sender.selectedSegmentIndex == 0 {
//            UserData.sharedInstance.selectedSeason = "SS"
//            SettingsController(tmpSelectedLectures: self.tmpSelectedLectures).clearAllSettings()
//        }else{
//            UserData.sharedInstance.selectedSeason = "WS"
//            SettingsController(tmpSelectedLectures: self.tmpSelectedLectures).clearAllSettings()
//        }
    }
    
    func hanldeCalendarSyncChanged() {
        if (UserData.sharedInstance.callenderSync) {
            syncSwitch.setOn(true, animated: true)
        } else {
            syncSwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func syncSwitchChanged(_ sender: UISwitch) {
        //Auslagern in eigenen Controller
        if (syncSwitch.isOn) {
            switch CalendarController().createCalendar() {
            case EKAuthorizationStatus.denied:
                showAccessAlert()
                UserData.sharedInstance.callenderSync = false
                syncSwitch.setOn(false, animated: true)
                break
            case EKAuthorizationStatus.notDetermined:
                UserData.sharedInstance.callenderSync = false
                syncSwitch.setOn(false, animated: true)
                break
            default:
                UserData.sharedInstance.callenderSync = true
                syncSwitch.setOn(true, animated: true)
                break
            }
        } else {
            CalendarController().removeCalendar()
            UserData.sharedInstance.callenderSync = false
        }
    }
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
//        saveChangesButton.setTitle("0 Änderungen übernehmen", for: .normal)
//        
//        if (syncSwitch.isOn) {
//            let resultCalendarRoutine = CalendarController().CalendarRoutine()
//            
//            if (!resultCalendarRoutine) {
//                showAccessAlert()
//                syncSwitch.setOn(false, animated: true)
//            }
//        }
        settingsController.commitChanges()
    }
    
    func showAccessAlert() {
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
        }else if (segue.identifier == "SettingsToSemesters"){
            
            let vc = segue.destination as! SemesterTableViewController
            vc.tmpSelectedCourses = settingsController.tmpSelectedCourses
            vc.tmpSelectedSemesters = settingsController.tmpSelectedSemesters
            vc.tmpSelectedLectures = settingsController.tmpSelectedLectures
        }else if (segue.identifier == "SettingsToLectures"){
            
            let vc = segue.destination as! LecturesViewController
            vc.tmpSelectedLectures = settingsController.tmpSelectedLectures
            vc.tmpSelectedSemesters = settingsController.tmpSelectedSemesters
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = tabBarController.selectedIndex
    
        if(index == 2){
            settingsController = SettingsController()
        }
    }
}
