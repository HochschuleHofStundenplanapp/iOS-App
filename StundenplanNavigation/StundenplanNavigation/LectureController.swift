//
//  LectureController.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 07.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit
import StundenplanFramework

class LectureController: NSObject, DataObserverProtocol {
    
    var myJobManager: JobManager = JobManager()
    
    var tmpSelectedSeason: String
    var tmpSelectedLectures: TmpSelectedLectures
    var tmpSelectedSemesters: TmpSelectedSemesters
    
    init(tmpSelectedLectures: TmpSelectedLectures, tmpSelectedSemesters: TmpSelectedSemesters, tmpSelectedSeason: String){
        self.tmpSelectedLectures = tmpSelectedLectures
        self.tmpSelectedSemesters = tmpSelectedSemesters
        self.tmpSelectedSeason = tmpSelectedSeason
    }

    func loadAllLectures() -> Void {
        
        AllLectures().clear()
        self.myJobManager = JobManager()
        self.myJobManager.addNewObserver(o: self)
        let selectedSemesters = tmpSelectedSemesters.allSemesters()
        
        for semester in selectedSemesters.dropLast() {
            
            let myUrl : String = "\(Constants.baseURI)client.php?f=Schedule&stg=\(semester.course.contraction)&sem=\(semester.name)&tt=\(tmpSelectedSeason)"
            let urlString = myUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            myJobManager.NetworkJob(url: urlString, username: Constants.username, password: Constants.password)
        }
        
        if (selectedSemesters.count != 0) {
            //Hole das Letzte Item der doppelten For-Schleife
            let semesterLastItem = selectedSemesters.last!
            
            //Markiere letzets Item im Job Manager
            let myUrl = "\(Constants.baseURI)client.php?f=Schedule&stg=\(semesterLastItem.course.contraction)&sem=\(semesterLastItem.name)&tt=\(tmpSelectedSeason)"
            let urlString = myUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            myJobManager.NetworkJob(url: urlString, username: Constants.username, password: Constants.password,isLastJob: true)
        }
    }
    
    /// speichert die zurückgegeben AnyObjects in ein AnyObjects Array
    ///
    /// - Parameter o: o Zurückgegebenes AnyObject
    func update (o:AnyObject) -> Void {
        
        let dataArray = o as! [(Data?, Error?)]
        
        let selectedSemesters = tmpSelectedSemesters.allSemesters()
        
        for errorObject in dataArray{
            if errorObject.1 != nil{
                notifyDownlaodFailed()
                return
            }
        }
        
        for (index, element) in dataArray.enumerated() {
//            print(String(data: element.0!, encoding: String.Encoding.utf8)! as String)
            
            guard let data = element.0 else {
                return
            }
            
            AllLectures().append(lectures: (JsonLectures(data: data, semester: selectedSemesters[index])?.lectures!)!)
        }
        AllLectures().sort()

        self.notifyDownlaodEnded()
    }
    
    func selectAllLectures() {
        tmpSelectedLectures.set(lectures: AllLectures().getLectures())
    }
    
    func deselectAllLectures(){
        tmpSelectedLectures.clear()
    }
    
    func toggleLecture(at indexPath: IndexPath) {
        let clickedLecture = AllLectures().getElement(at: indexPath)
        
        if tmpSelectedLectures.contains(lecture: clickedLecture){
            let indexPath = tmpSelectedLectures.getIndexPath(for: clickedLecture)
            print("toggleLecture(at indexPath: IndexPath) L: \(indexPath)")
            tmpSelectedLectures.remove(at: indexPath)
            
        } else {
            tmpSelectedLectures.add(lecture: clickedLecture)
            
        }
    }
    
    func notifyDownlaodEnded(){
        NotificationCenter.default.post(name: .lecturesDownloadEnded , object: nil)
    }
    
    func notifyDownlaodFailed(){
        NotificationCenter.default.post(name: .lecturesDownloadFailed , object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func cancelLoading() -> Void {
        myJobManager.cancelAllNetworkJobs()
    }
}
