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

    
    func loadCourses(tableView: CourseTableViewController){
        
        tableView.beginDownload()
        let season = Settings.sharedInstance.tmpSeason.rawValue
        
        let urlString = "https://www.hof-university.de/soap/client.php?f=Courses&tt=\(season)"
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
                    print("error=\(error)")
                    print("Connection failed")
                    tableView.showNoInternetAlert()
                    
                } else{
                
                dump(JsonCourses(data: data!)?.courses)
                Settings.sharedInstance.tmpCourses.addCourses(courses: (JsonCourses(data: data!)?.courses)!)
                
                    tableView.endDownload()
                }
            })
        })
        task.resume()
        
    }
    
    func loadSchedule(tableView: UITableView){
    
        Settings.sharedInstance.tmpSchedule.clearSchedule()
        
        let season = Settings.sharedInstance.tmpSeason.rawValue
        let selectedCourses = Settings.sharedInstance.tmpCourses.selectedCourses()
    
        for course in selectedCourses{
        
            let selectedSemesters = course.semesters.selectedSemesters()
            let courseName = course.contraction
            
            for semester in selectedSemesters{
            
                let semesterName = semester.name
                
                loadScheduleFromServer(tableView: tableView, semester: semesterName ,course: courseName, season: season)
            }
        }
    }
    
    private func loadScheduleFromServer(tableView: UITableView, semester: String, course: String, season: String){
    
        let plainUrlString = "https://www.hof-university.de/soap/client.php?f=Schedule&stg=\(course)&sem=\(semester)&tt=\(season)"
        
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
                                
                Settings.sharedInstance.tmpSchedule.addSchedule(lectures: (JsonSchedule(data: data!, course: course)?.schedule!)!)
                tableView.reloadData()
            })
        })
        task.resume()
    }
    
//    func loadChanges(tableView: UITableView){
//        
//        let season = Settings.sharedInstance.season.rawValue
//        let selectedCourses = Settings.sharedInstance.courses.selectedCourses()
//        
//        for course in selectedCourses{
//            
//            let selectedSemesters = course.semesters.selectedSemesters()
//            let courseName = course.contraction
//            
//            for semester in selectedSemesters{
//                
//                let semesterName = semester.name
//                
//                loadChangesFromServer(season: season, semester: semesterName, course: courseName)
//            }
//        }
//    }
//    
//    private func loadChangesFromServer(season : String, semester : String, course : String){
//    
//        let urlString = "https://www.hof-university.de/soap/client.php?f=Changes&stg=\(course)&sem=\(semester)&tt=\(kSecAttrSerialNumber)"
//
//        let passInfo = String(format: "%@:%@", username, password)
//        let passData = passInfo.data(using: .utf8)
//        let passCredential = passData?.base64EncodedString()
//        let url = URL(string: urlString)
//        var request = URLRequest(url: url!)
//        request.setValue("Basic \(passCredential!)", forHTTPHeaderField: "Authorization")
//        request.httpMethod = "POST"
//        
//        let session = URLSession.shared
//        let task = session.dataTask(with: request, completionHandler: {
//            data, response, error in
//            
//            DispatchQueue.main.async(execute: { () -> Void in
//                
//                dump(JsonChanges(data: data!)?.changes)
//            })
//        })
//        task.resume()
//    }
}
