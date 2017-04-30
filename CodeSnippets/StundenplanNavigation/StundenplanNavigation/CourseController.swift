//
//  CourseController.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 27.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class CourseController: NSObject, DataObserverProtocol {

    var myJobManager : JobManager = JobManager()
    
    func loadAllCourses() -> Void {
        
        self.myJobManager.addNewObserver(o: self)
      
        let selectedSeason = UserData.sharedInstance.season
        
        //Markiere letzets Item im Job Manager
        let myUrl = "\(Constants.baseURI)client.php?f=Courses&tt=\(selectedSeason)"
        let urlString = myUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        myJobManager.NetworkJob(url: urlString, username: Constants.username, password: Constants.password,isLastJob: true)
    }
    
    func notifyDownlaodEnded(){
        NotificationCenter.default.post(name: Notification.Name("DownloadEnded") , object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(Notification.Name("DownloadEnded"))
    }
    
    /// speichert die zurückgegeben AnyObjects in ein AnyObjects Array
    ///
    /// - Parameter o: o Zurückgegebenes AnyObject
    func update (o:AnyObject) -> Void
    {
        let b = o as! Array<Data>
        
        for dataObject in b {
            ServerData.sharedInstance.allCourses = (JsonCourses(data: dataObject)?.courses!)!
            dump(ServerData.sharedInstance.allCourses)
            notifyDownlaodEnded()
        }
    }
    
    /// Bricht im JobManager alle Netzwerkjobs ab
    func cancelAllNetworkJobs() -> Void {
        myJobManager.cancelAllNetworkJobs()
    }
}
