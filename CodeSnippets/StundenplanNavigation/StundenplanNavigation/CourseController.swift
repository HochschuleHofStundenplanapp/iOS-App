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
    
    func loudAllCourses() -> Void {
        
        self.myJobManager.addNewObserver(o: self)
        
//        let season = Settings.sharedInstance.savedSsws.rawValue
//        let selectedCourses = Settings.sharedInstance.savedCourses.selectedCourses()
//        
//        Settings.sharedInstance.savedChanges.changes = []
//        // cntChanges = 0
//        for course in selectedCourses{
//            
//            
//            let selectedSemesters = course.semesters.selectedSemesters()
//            let courseName = course
//            for semester in selectedSemesters.dropLast() {
//                let semesterName  =  semester.name as! String
//                var myUrl : String = "\(baseURI)client.php?f=Changes&stg=\(courseName.contraction)&sem=\(semesterName)&tt=\(season)"
//                let urlString = myUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//                
//                
//                myJobManager.NetworkJob(url: urlString, username: username, password: password)
//                
//                
//            }
//            //
//            
//        }
        
        //Hole das Letzte Item der doppelten For-Schleife
//        let courseNameLastItem = selectedCourses.last!.contraction
//        let selectedSemesterLastItem = selectedCourses.last!.semesters.selectedSemesters().last!.name
    
        let selectedSeason = UserData.sharedInstance.season
        
        //Markiere letzets Item im Job Manager
        let myUrl = "\(Constants.baseURI)client.php?f=Courses&tt=\(selectedSeason)"
        let urlString = myUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        myJobManager.NetworkJob(url: urlString, username: Constants.username, password: Constants.password,isLastJob: true)
        print("Letzen Job hinzugefügt")
    }
    
    /// speichert die zurückgegeben AnyObjects in ein AnyObjects Array
    ///
    /// - Parameter o: o Zurückgegebenes AnyObject
    func update (o:AnyObject) -> Void
    {
        let b = o as! Array<Data>
        
        for dataObject in b {
            print(String(data: dataObject, encoding: String.Encoding.utf8)! as String)
                //TODO: JsonChanges muss umgeschrieben werden - Darf kein Course erwarten ..        
        }
        
        print("ScheduleChanges Controller All Jobs Done")
    }
    
    /// Bricht im JobManager alle Netzwerkjobs ab
    func cancelAllNetworkJobs() -> Void {
        myJobManager.cancelAllNetworkJobs()
    }
}
