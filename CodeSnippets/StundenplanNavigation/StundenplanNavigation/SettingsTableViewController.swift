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

        //courseTableViewCell.isUserInteractionEnabled = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.tintColor = UIColor(red: 0.0039, green: 0.4078, blue: 0.6824, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 0.0039, green: 0.4078, blue: 0.6824, alpha: 1.0)]
        
        Settings.sharedInstance.tmpSchedule.extractSelectedLectures()
        let counter = Settings.sharedInstance.countChanges()
        saveChangesButton.setTitle("\(counter) Änderungen übernehmen", for: .normal)
        
        if Settings.sharedInstance.tmpSeason == .summer {
            segmentControl.selectedSegmentIndex = 0
        }else{
            segmentControl.selectedSegmentIndex = 1
        }
        
        setDetailLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sectionChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            Settings.sharedInstance.tmpSeason = .summer
        }else{
            Settings.sharedInstance.tmpSeason = .winter
        }
    }
    
    @IBAction func saveChangesButton(_ sender: UIButton) {
        Settings.sharedInstance.commitChanges()
        saveChangesButton.setTitle("0 Änderungen übernehmen", for: .normal)
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
        
        //Alle selektierten Semester
        let allSelectedSemesters : [Semesters] = Settings.sharedInstance.tmpCourses.selectedSemesters()
        var allSelectedSemester : [Semester] = []
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
        }
        else
        {
            selectedSemesterString = selectedSemester[1]
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
        }
        
        print("selektierte Semester: ")
        print(selectedSemesterString)
        
    }
}
