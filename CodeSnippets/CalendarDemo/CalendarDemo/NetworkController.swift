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
    
    func loadCourses(tableView: UITableView, season : String){
            
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

                dump(JsonCourses(data: data!)?.courses)

                Settings.sharedInstance.courses.addCourses(courses: (JsonCourses(data: data!)?.courses)!)
                tableView.reloadData()
            })
        })
        task.resume()
        
    }
    
    func loadSchedule(tableView: UITableView, season : String, semester : String, course : String){
    
        let urlString = "https://www.hof-university.de/soap/client.php?f=Schedule&stg=\(course)&sem=\(semester)&tt=\(season)"

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
                
                dump(JsonSchedule(data: data!, course: course)?.schedule)
                
                Settings.sharedInstance.schedule.addSchedule(lectures: (JsonSchedule(data: data!, course: course)?.schedule!)!)
                tableView.reloadData()
            })
        })
        task.resume()
    }
    
    func loadChanges(ssws : String, semester : String, stg : String){
    
        let urlString = "https://www.hof-university.de/soap/client.php?f=Changes&stg=\(stg)&sem=\(semester)&tt=\(ssws)"

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
                
                dump(JsonChanges(data: data!)?.changes)
            })
        })
        task.resume()
    }
}
