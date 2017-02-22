//
//  NetworkController.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 12.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import UIKit

class NetworkController: NSObject {
    
    private let username = "soapuser"
    private let password = "F%98z&12"
    private let baseURI = "https://www.hof-university.de/soap/"
    
    var cntSemesters = 0
    var cntChanges = 0
    
    func loadCourses(tableView: CourseTableViewController){
        
        tableView.beginDownload()
        let season = Settings.sharedInstance.tmpSeason.rawValue
        
        let urlString = "\(baseURI)client.php?f=Courses&tt=\(season)"
        let passInfo = String(format: "%@:%@", username, password)
        let passData = passInfo.data(using: .utf8)
        let passCredential = passData?.base64EncodedString()
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.setValue("Basic \(passCredential!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            data, response, error in
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                if error != nil {
                    Settings.sharedInstance.tmpCourses.list.removeAll()
                    tableView.showNoInternetAlert()
                    tableView.endDownload()
                } else{
                    Settings.sharedInstance.setTmpCourses(courses: (JsonCourses(data: data!)?.courses)!)
                    tableView.endDownload()
                }
            })
        })
        task.resume()
        
    }
    
    func loadSchedule(tableView: LecturesTableViewController){
        
        let season = Settings.sharedInstance.tmpSeason.rawValue
        let selectedCourses = Settings.sharedInstance.tmpCourses.selectedCourses()
        
        cntSemesters = 0
        for course in selectedCourses{
            
            let selectedSemesters = course.semesters.selectedSemesters()
            //let courseName = course.contraction
            Settings.sharedInstance.tmpSchedule.clearSchedule()
            
            for semester in selectedSemesters{
                cntSemesters += 1
                //let semesterName = semester.name
                loadScheduleFromServer(tableView: tableView, semester: semester ,course: course, season: season)
                
            }
        }
    }
    
    private func loadScheduleFromServer(tableView: LecturesTableViewController, semester: Semester, course: Course, season: String){
        
        let plainUrlString = "\(baseURI)client.php?f=Schedule&stg=\(course.contraction)&sem=\(semester.name)&tt=\(season)"
        
        let passInfo = String(format: "%@:%@", username, password)
        let passData = passInfo.data(using: .utf8)
        let passCredential = passData?.base64EncodedString()
        let urlString = plainUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.setValue("Basic \(passCredential!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            data, response, error in
            DispatchQueue.main.async(execute: { () -> Void in
                self.cntSemesters -= 1
                if error != nil {
                    Settings.sharedInstance.copyData()
                    tableView.showNoInternetAlert()
                    tableView.endDownload()
                } else{
                    Settings.sharedInstance.tmpSchedule.addSchedule(lectures: (JsonSchedule(data: data!, course: course, semester: semester)?.schedule!)!)
                    if (self.cntSemesters == 0)
                    {
                        Settings.sharedInstance.tmpSchedule.sort()
                        tableView.endDownload()
                    }
                    
                }
            })
        })
        task.resume()
    }
    
        func loadChanges(tableView: ScheduleChangesTableViewController){
    
            //Clear Changes
            
            let season = Settings.sharedInstance.savedSsws.rawValue
            let selectedCourses = Settings.sharedInstance.savedCourses.selectedCourses()
            
            Settings.sharedInstance.savedChanges.changes = []
            cntChanges = 0
            for course in selectedCourses{
    
                let selectedSemesters = course.semesters.selectedSemesters()
                let courseName = course
    
                for semester in selectedSemesters{
                    cntChanges += 1
                    let semesterName = semester.name
    
                    loadChangesFromServer(tableView: tableView, season: season, semester: semesterName, course: courseName)
                }
            }
        }
    
        private func loadChangesFromServer(tableView: ScheduleChangesTableViewController, season : String, semester : String, course : Course){
    
            let plainUrlString = "\(baseURI)client.php?f=Changes&stg=\(course.contraction)&sem=\(semester)&tt=\(season)"
    
            let passInfo = String(format: "%@:%@", username, password)
            let passData = passInfo.data(using: .utf8)
            let passCredential = passData?.base64EncodedString()
            let urlString = plainUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url = URL(string: urlString)
            var request = URLRequest(url: url!)
            request.setValue("Basic \(passCredential!)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
    
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: {
                data, response, error in
    
                DispatchQueue.main.async(execute: { () -> Void in
                    self.cntChanges -= 1
                    if error != nil {
                        tableView.showNoInternetAlert()
                        tableView.endDownload()
                    } else{
                        Settings.sharedInstance.savedChanges.addChanges(cl: (JsonChanges(data: data!, course: course)!.changes))
                        Settings.sharedInstance.compareScheduleAndChanges()
                        if (self.cntChanges == 0)
                        {
                            tableView.endDownload()
                        }
                    }
                })
            })
            task.resume()
        }
}
