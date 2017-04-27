//
//  ScheduleChangesController.swift
//  StundenplanNavigation
//
//  Created by Andreas Wolf on 20.04.17.
//  Copyright © 2017 Haxnpeter. All rights reserved.
//

import UIKit

class ScheduleChangesController: NSObject, DataObserverProtocol{
    
    var myJobManager : JobManager = JobManager()
    
    func handleChanges() -> Void
    {

//        self.myJobManager.addNewObserver(o: self)
//        
//
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
//               let semesterName  =  semester.name as! String
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
//       
//        //Hole das Letzte Item der doppelten For-Schleife
//        let courseNameLastItem = selectedCourses.last!.contraction
//        let selectedSemesterLastItem = selectedCourses.last!.semesters.selectedSemesters().last!.name
//        
//        //Markiere letzets Item im Job Manager
//        let myUrl = "\(baseURI)client.php?f=Changes&stg=\(courseNameLastItem)&sem=\(selectedSemesterLastItem as! String)&tt=\(season)"
//        let urlString = myUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        
//        
//        myJobManager.NetworkJob(url: urlString, username: username, password: password,isLastJob: true)
//        print("Letzen Job hinzugefügt")
//
    }
    
    /// speichert die zurückgegeben AnyObjects in ein AnyObjects Array
    ///
    /// - Parameter o: o Zurückgegebenes AnyObject
    func update (o:AnyObject) -> Void
    {
//        print("Das Dataobject \(o)")
//        let b = o as! Array<Data>
//        
//        for dataObject in b {
//        print("Dataobject kommt:")
//            print(String(data: dataObject, encoding: String.Encoding.utf8)! as String)
//            //TODO: JsonChanges muss umgeschrieben werden - Darf kein Course erwarten ..
//            
//            // Settings.sharedInstance.savedChanges.addChanges(cl: (JsonChanges(data: dataObject)))
//        }
//        
//     print("ScheduleChanges Controller All Jobs Done")
//        
    }
    /// Bricht im JobManager alle Netzwerkjobs ab
   func cancelAllNetworkJobs() -> Void  {
        myJobManager.cancelAllNetworkJobs()
        
    }
    
}
