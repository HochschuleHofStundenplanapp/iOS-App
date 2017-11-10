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
    
    var tmpSelectedCourses : TmpSelectedCourses
    var tmpSelectedSemesters : TmpSelectedSemesters
    var tmpSelectedLectures : TmpSelectedLectures
    var tmpSelectedSeason : String

    init (tmpSelectedCourses: TmpSelectedCourses, tmpSelectedSemesters: TmpSelectedSemesters, tmpSelectedLectures: TmpSelectedLectures, tmpSelectedSeason: String){
        self.tmpSelectedCourses = tmpSelectedCourses
        self.tmpSelectedSemesters = tmpSelectedSemesters
        self.tmpSelectedLectures = tmpSelectedLectures
        self.tmpSelectedSeason = tmpSelectedSeason
    }
    
    func loadAllCourses() -> Void {
        AllCourses().clear()
        
        self.myJobManager = JobManager()
        self.myJobManager.addNewObserver(o: self)
        
        //Markiere letzets Item im Job Manager
        let myUrl = "\(Constants.baseURI)client.php?f=Courses&tt=\(tmpSelectedSeason)"
        let urlString = myUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        myJobManager.NetworkJob(url: urlString, username: Constants.username, password: Constants.password,isLastJob: true)
    }
    
    func toggleCourse(at row : Int) {
        
        let clickedCourse = AllCourses().course(at: row)
        
        if tmpSelectedCourses.contains(course: clickedCourse) {
            //Studiengang abwählen
            tmpSelectedCourses.remove(course: clickedCourse)
            
            //Zugehörige selektierte Semester löschen
            tmpSelectedSemesters.removeSemester(with: clickedCourse)
            
            //Zugehörige selektierte Vorlesungen entfernen
            tmpSelectedLectures.removeLectures(with: clickedCourse)
        }else{
            //Studiengang auswählen
            tmpSelectedCourses.append(course: clickedCourse)
        }
    }
    
    func notifyDownloadEnded(){
        NotificationCenter.default.post(name: .coursesDownloadEnded , object: nil)
    }
    
    func notifyDownloadFailed(){
        NotificationCenter.default.post(name: .coursesDownloadFailed , object: nil)
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
        
        for errorObject in dataArray{
            if errorObject.1 != nil{
                notifyDownloadFailed()
                return
            }
        }
        
        for dataObject in dataArray {
//            print(String(data: dataObject.0!, encoding: String.Encoding.utf8)! as String)
                        
            guard let data = dataObject.0 else {
                return
            }
            
            AllCourses().setCourses(courses: (JsonCourses(data: data)?.courses!)!)
        }
        notifyDownloadEnded()
    }
    
    func cancelLoading(){
        myJobManager.cancelAllNetworkJobs()
    }
}
