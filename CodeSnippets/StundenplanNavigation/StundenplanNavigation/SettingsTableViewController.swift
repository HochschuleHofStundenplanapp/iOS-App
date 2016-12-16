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
        saveChangesButton.setTitle("\(counter) Änderungen übernehmen", for: .normal)
        
        if Settings.sharedInstance.tmpSeason == .summer {
            segmentControl.selectedSegmentIndex = 0
        }else{
            segmentControl.selectedSegmentIndex = 1
        }
        //disableCells()
        setDetailLabels()
    }
    
    private func disableCells(){
        if(Settings.sharedInstance.tmpCourses.hasSelectedCourses()){
            semesterTableViewCell.isUserInteractionEnabled = true
            semesterTableViewCell.textLabel?.isEnabled = true
            semesterTableViewCell.detailTextLabel?.isEnabled = true
            
//            if(hasSelectedSemester)
        }else{
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
        
        tabBarController?.tabBar.tintColor = UIColor(red: 0.0039, green: 0.4078, blue: 0.6824, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 0.0039, green: 0.4078, blue: 0.6824, alpha: 1.0)]
        
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sectionChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            Settings.sharedInstance.tmpSeason = .summer
            setDetailLabels()
        }else{
            Settings.sharedInstance.tmpSeason = .winter
            setDetailLabels()
        }
    }
    
    
    @IBAction func syncSwitchChanged(_ sender: UISwitch) {
        if(!syncSwitch.isOn){
        CalendarInterface.sharedInstance.removeCalendar()
        }
    }
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
        // neu hinzugefügte und gelöschte Vorlesungen bekommen
        // IDS werden noch nicht gespeichert !
        var addedLectures = Settings.sharedInstance.tmpSchedule.addedLectures(oldSchedule: Settings.sharedInstance.savedSchedule)
        var removedLectures = Settings.sharedInstance.tmpSchedule.removedLectures(oldSchedule: Settings.sharedInstance.savedSchedule)
        
        Settings.sharedInstance.commitChanges()
        
        saveChangesButton.setTitle("0 Änderungen übernehmen", for: .normal)
        
        if (syncSwitch.isOn) {
            if(!addedLectures.isEmpty)
            {
            CalendarInterface().createAllEvents(lectures: addedLectures)
            }
            if(!removedLectures.isEmpty)
            {
            CalendarInterface.sharedInstance.removeAllEvents(lectures: removedLectures)
            }
            
        }
        
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
        
        for i in selectedSemester{
            print("Selektierte Semester \(i)")
        }
        
        var isEmpty = true
        for i in selectedSemester{
            if (i != "|"){
                isEmpty = false
            }
        }
        
        print("isEmpty: \(isEmpty)")
        
        if(isEmpty){
            selectedSemesterString = "..."
            semesterTableViewCell.detailTextLabel?.text = selectedSemesterString
            lecturesTableViewCell.detailTextLabel?.text = "..."

        }
        else
        {
            selectedSemesterString = selectedSemester[1]
            print("selectedSemesterString : \(selectedSemesterString)")
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
        
        //Anzahl selektierte Vorlesungen
        let countSelectedLectures = Settings.sharedInstance.tmpSchedule.selLectures.count
        let selection = Settings.sharedInstance.tmpCourses.hasSelectedCourses()
        print("countSelectedLectures: \(countSelectedLectures)")
        if(selection == false){
            lecturesTableViewCell.detailTextLabel?.text = "..."
        }
        else{
            if(countSelectedLectures != 0 ){
                lecturesTableViewCell.detailTextLabel?.text = "Vorlesungen gewählt"
            }
        }
    }
}
