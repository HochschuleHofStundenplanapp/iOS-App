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
        
        self.myJobManager = JobManager()
        self.myJobManager.addNewObserver(o: self)
      
        let selectedSeason = UserData.sharedInstance.selectedSeason
        
        //Markiere letzets Item im Job Manager
        let myUrl = "\(Constants.baseURI)client.php?f=Courses&tt=\(selectedSeason)"
        let urlString = myUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        myJobManager.NetworkJob(url: urlString, username: Constants.username, password: Constants.password,isLastJob: true)
    }
    
    func toggleCourse(at indexPath: IndexPath) {
        
        let clickedCourse = ServerData.sharedInstance.allCourses[indexPath.row]
        
        if SelectedCourses().contains(course: clickedCourse) {
            //Studiengang abwählen
            let index = SelectedCourses().indexPath(of: clickedCourse)
            SelectedCourses().remove(at: index)
            
            //Zugehörige selektierte Semester löschen
            self.removeSemester(for: clickedCourse)
            
            //Zugehörige selektierte Vorlesungen entfernen
            TmpSelectedLectures().removeLectures(with: clickedCourse)
        }else{
            //Studiengang auswählen
            UserData.sharedInstance.selectedCourses.append(clickedCourse)
        }
    }
    
    private func removeSemester(for course: Course){
        for semester in UserData.sharedInstance.selectedSemesters{
            if(semester.course == course){
                let index = UserData.sharedInstance.selectedSemesters.index(of: semester)
                UserData.sharedInstance.selectedSemesters.remove(at: index!)
            }
        }
    }
    
    func notifyDownloadEnded(){
        NotificationCenter.default.post(name: .coursesDownloadEnded , object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// speichert die zurückgegeben AnyObjects in ein AnyObjects Array
    ///
    /// - Parameter o: o Zurückgegebenes AnyObject
    func update (o:AnyObject) -> Void
    {
        let dataArray = o as! [(Data?, Error?)]
        
        for dataObject in dataArray {
            print(String(data: dataObject.0!, encoding: String.Encoding.utf8)! as String)
            
            if let error = dataObject.1{
                // handle error
            }
            
            guard let data = dataObject.0 else {
                return
            }
            
            ServerData.sharedInstance.allCourses = (JsonCourses(data: data)?.courses!)!
        }
        notifyDownloadEnded()
    }
    
    func cancelLoading(){
        myJobManager.cancelAllNetworkJobs()
    }
}
