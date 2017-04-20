//
//  SettingsTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Settings.sharedInstance.tmpSchedule.extractSelectedLectures()
        let counter = Settings.sharedInstance.countChanges()
        
        var title = "\(counter) Änderungen übernehmen"
        
        if (counter == 0){
            title = "Änderungen übernehmen"
        }
        
        saveChangesButton.setTitle(title, for: .normal)
        
        if Settings.sharedInstance.tmpSeason == .Summer {
            segmentControl.selectedSegmentIndex = 0
        }else{
            segmentControl.selectedSegmentIndex = 1
        }
        disableCells()
        setDetailLabels()
        
        syncSwitch.isOn = Settings.sharedInstance.savedCalSync
        
    }
    
    private func disableCells(){
        
        //Variable setzten, ob Semester selektiert wurden
        let allSelectedSemesters : [Semesters] = Settings.sharedInstance.tmpCourses.selectedSemesters()
        var hasSelectedSemester = false
        for i in allSelectedSemesters {
            for j in i.list{
                if (j.selected == true){
                    hasSelectedSemester = true
                }
            }
        }
        
        if(Settings.sharedInstance.tmpCourses.hasSelectedCourses()){
            semesterTableViewCell.isUserInteractionEnabled = true
            semesterTableViewCell.textLabel?.isEnabled = true
            semesterTableViewCell.detailTextLabel?.isEnabled = true
            
            if(hasSelectedSemester){
                lecturesTableViewCell.isUserInteractionEnabled = true
                lecturesTableViewCell.textLabel?.isEnabled = true
                lecturesTableViewCell.detailTextLabel?.isEnabled = true
            }
            else{
                lecturesTableViewCell.isUserInteractionEnabled = false
                lecturesTableViewCell.textLabel?.isEnabled = false
                lecturesTableViewCell.detailTextLabel?.isEnabled = false
            }
        }
        else{
            semesterTableViewCell.isUserInteractionEnabled = false
            semesterTableViewCell.textLabel?.isEnabled = false
            semesterTableViewCell.detailTextLabel?.isEnabled = false
            
            lecturesTableViewCell.isUserInteractionEnabled = false
            lecturesTableViewCell.textLabel?.isEnabled = false
            lecturesTableViewCell.detailTextLabel?.isEnabled = false
        }
        //        if(Settings.sharedInstance.tmpCourses.){
        //            lecturesTableViewCell.isUserInteractionEnabled = true
        //            lecturesTableViewCell.textLabel?.isEnabled = true
        //            lecturesTableViewCell.detailTextLabel?.isEnabled = true
        //        }else{
        //            lecturesTableViewCell.isUserInteractionEnabled = false
        //            lecturesTableViewCell.textLabel?.isEnabled = false
        //            lecturesTableViewCell.detailTextLabel?.isEnabled = false
        //        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.tintColor = Constants.HAWBlue
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.HAWBlue]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sectionChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            Settings.sharedInstance.tmpSeason = .Summer
            setDetailLabels()
        }else{
            Settings.sharedInstance.tmpSeason = .Winter
            setDetailLabels()
        }
    }
    
    
    @IBAction func syncSwitchChanged(_ sender: UISwitch) {
        
        if(syncSwitch.isOn){
            Settings.sharedInstance.savedCalSync = true
            if(CalendarController().createCalendar() == false){
                showAccessAlert()
                Settings.sharedInstance.savedCalSync = false
                syncSwitch.setOn(false, animated: true)
            }
        } else {
            CalendarController().removeCalendar()
            Settings.sharedInstance.savedCalSync = false
        }
    }
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
        let vData = DataObject()
        
        saveChangesButton.setTitle("0 Änderungen übernehmen", for: .normal)
        
        if (syncSwitch.isOn) {
            let resultCalendarRoutine = CalendarController().CalendarRoutine()
            
            if (!resultCalendarRoutine) {
                showAccessAlert()
                syncSwitch.setOn(false, animated: true)
            }
        }

        Settings.sharedInstance.tmpSchedule.deselectUnusedLectures()
        
        Settings.sharedInstance.commitChanges()
        
        
        vData.Version = 1
        VersionDataObjectPersistency().saveDataObject(vData)
        DataObjectPersistency().saveDataObject(items: Settings.sharedInstance)
        
        

    }
    
    func setDetailLabels(){
        
        //Alle selektierten Courses
        let selectedCourses : [String] = Settings.sharedInstance.tmpCourses.selectedCoursesName()
        
        if (selectedCourses.count == 0){
            selectedCoursesString = "..."
        }
        else{
            selectedCoursesString = selectedCourses[0]
        }
        if(selectedCourses.count > 1){
            for i in 1..<selectedCourses.count{
                selectedCoursesString.append(", " + selectedCourses[i])
            }
        }
        courseTableViewCell.detailTextLabel?.text = selectedCoursesString
        semesterTableViewCell.detailTextLabel?.text = "..."
        lecturesTableViewCell.detailTextLabel?.text = "..."
        
        //Alle selektierten Semester
        let allSelectedSemesters : [Semesters] = Settings.sharedInstance.tmpCourses.selectedSemesters()
        //var allSelectedSemester : [Semester] = []
        var selectedSemester : [String] = []
        
        for i in allSelectedSemesters {
            selectedSemester.append("|")
            for j in i.list{
                if (j.selected == true){
                    selectedSemester.append(j.name)
                }
            }
        }
        
        var isEmpty = true
        for i in selectedSemester{
            if (i != "|"){
                isEmpty = false
            }
        }
        
        if(isEmpty){
            selectedSemesterString = "..."
            semesterTableViewCell.detailTextLabel?.text = selectedSemesterString
            lecturesTableViewCell.detailTextLabel?.text = "..."
            
        }
        else
        {
            selectedSemesterString = selectedSemester[1]
            semesterTableViewCell.detailTextLabel?.text = selectedSemesterString
            lecturesTableViewCell.detailTextLabel?.text = "..."
            
        }
        
        if(selectedSemester.count > 2){
            for i in 2..<selectedSemester.count{
                if selectedSemester[i] == "|"{
                    selectedSemesterString.append(" | ")
                }
                else if (selectedSemester[i-1] == "|" && selectedSemester[i] != "|"){
                    selectedSemesterString.append(selectedSemester[i])
                }
                else{
                    selectedSemesterString.append("," + selectedSemester[i])
                }
            }
            semesterTableViewCell.detailTextLabel?.text = selectedSemesterString
            lecturesTableViewCell.detailTextLabel?.text = "..."
            
        }
        
        lecturesTableViewCell.detailTextLabel?.text = " "
        //        Anzahl selektierte Vorlesungen
        //        FUNKTIONIERT NICHT!!! Grund: Die Information über selektierte Vorlesungen stimmt zu diesem Zeitpunkt im tmpSchedule nicht.
        
        //        let countSelectedLectures = Settings.sharedInstance.tmpSchedule.selLectures.count
        //        let selection = Settings.sharedInstance.tmpCourses.hasSelectedCourses()
        //        print("countSelectedLectures: \(countSelectedLectures)")
        //        if(selection == false){
        //            lecturesTableViewCell.detailTextLabel?.text = "..."
        //        }
        //        else{
        //            if(countSelectedLectures != 0 ){
        //                lecturesTableViewCell.detailTextLabel?.text = "Vorlesungen gewählt"
        //            }
        //        }
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
}
