//
//  LectureController.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 07.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class LectureController: NSObject, DataObserverProtocol {
    
    var myJobManager : JobManager = JobManager()
    
    func loadAllLectures() -> Void {
    
        self.myJobManager.addNewObserver(o: self)
    
        let selectedSemesters = UserData.sharedInstance.selectedSemesters

        for semester in selectedSemesters.dropLast() {
    
            let myUrl : String = "\(Constants.baseURI)client.php?f=Schedule&stg=\(semester.course.contraction)&sem=\(semester.name)&tt=\(semester.season)"
            let urlString = myUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            print(myUrl)
            
            myJobManager.NetworkJob(url: urlString, username: Constants.username, password: Constants.password)
        }
    
        //Hole das Letzte Item der doppelten For-Schleife
        let semesterLastItem = selectedSemesters.last!

        //Markiere letzets Item im Job Manager
        let myUrl = "\(Constants.baseURI)client.php?f=Schedule&stg=\(semesterLastItem.course.contraction)&sem=\(semesterLastItem.name)&tt=\(semesterLastItem.season)"
        let urlString = myUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    
        myJobManager.NetworkJob(url: urlString, username: Constants.username, password: Constants.password,isLastJob: true)
    }
    
    /// speichert die zurückgegeben AnyObjects in ein AnyObjects Array
    ///
    /// - Parameter o: o Zurückgegebenes AnyObject
    func update (o:AnyObject) -> Void {
            
        let dataArray = o as! [(Data?, Error?)]
        
        for dataObject in dataArray {
//            print(String(data: dataObject.0!, encoding: String.Encoding.utf8)! as String)
            
            if let error = dataObject.1{
                // handle error
            }
            
            guard let data = dataObject.0 else {
                return
            }
            
            ServerData.sharedInstance.schedule.addSchedule(lectures: (JsonLectures(data: data, semester: Semester())?.lectures!)!)
        }
        
        dump(ServerData.sharedInstance.schedule)
    }

    func cancelLoading() -> Void {
        myJobManager.cancelAllNetworkJobs()
    }
}
