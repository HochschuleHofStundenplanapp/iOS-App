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
        
        AllLectures().clear()
        self.myJobManager = JobManager()
        self.myJobManager.addNewObserver(o: self)
        let selectedSemesters = TmpSelectedSemesters().allSemesters()
        
        for semester in selectedSemesters.dropLast() {
            
            let myUrl : String = "\(Constants.baseURI)client.php?f=Schedule&stg=\(semester.course.contraction)&sem=\(semester.name)&tt=\(semester.season)"
            let urlString = myUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            myJobManager.NetworkJob(url: urlString, username: Constants.username, password: Constants.password)
        }
        
        if (selectedSemesters.count != 0) {
            //Hole das Letzte Item der doppelten For-Schleife
            let semesterLastItem = selectedSemesters.last!
            
            //Markiere letzets Item im Job Manager
            let myUrl = "\(Constants.baseURI)client.php?f=Schedule&stg=\(semesterLastItem.course.contraction)&sem=\(semesterLastItem.name)&tt=\(semesterLastItem.season)"
            let urlString = myUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            myJobManager.NetworkJob(url: urlString, username: Constants.username, password: Constants.password,isLastJob: true)
        }
    }
    
    /// speichert die zurückgegeben AnyObjects in ein AnyObjects Array
    ///
    /// - Parameter o: o Zurückgegebenes AnyObject
    func update (o:AnyObject) -> Void {
        
        let dataArray = o as! [(Data?, Error?)]
        
        let selectedSemesters = TmpSelectedSemesters().allSemesters()
        
        for (index, element) in dataArray.enumerated() {
//            print(String(data: element.0!, encoding: String.Encoding.utf8)! as String)
            
            if let error = element.1{
                // handle error
            }
            
            guard let data = element.0 else {
                return
            }
            
            AllLectures().append(lectures: (JsonLectures(data: data, semester: selectedSemesters[index])?.lectures!)!)
            
        }
        self.notifyDownlaodEnded()
    }
    
    func selectAllLectures() {
        let allLectures = AllLectures().getLectures()
        TmpSelectedLectures().set(lectures: allLectures)
    }
    
    func deselectAllLectures(){
        TmpSelectedLectures().clear()
    }
    
    func toggleLecture(at indexPath: IndexPath) {
        
        let clickedLecture = AllLectures().getElement(at: indexPath)
        
        if TmpSelectedLectures().contains(lecture: clickedLecture){
            let indexPath = TmpSelectedLectures().getIndexPath(for: clickedLecture)
            TmpSelectedLectures().remove(at: indexPath)
        } else {
            TmpSelectedLectures().add(lecture: clickedLecture)
        }
    }
    
    func notifyDownlaodEnded(){
        NotificationCenter.default.post(name: .lecturesDownloadEnded , object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func cancelLoading() -> Void {
        myJobManager.cancelAllNetworkJobs()
    }
}
