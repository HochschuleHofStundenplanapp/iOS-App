//
//  SettingsController.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 03.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class SettingsController: NSObject {
    
    var tmpSelectedCourses: TmpSelectedCourses
    var tmpSelectedSemesters: TmpSelectedSemesters
    var tmpSelectedLectures: TmpSelectedLectures
    var userDataCopy: UserData!
    
    override init() {
        userDataCopy = UserData.sharedInstance.copy() as! UserData
        
        tmpSelectedCourses = TmpSelectedCourses(userdata: userDataCopy)
        tmpSelectedSemesters = TmpSelectedSemesters(userdata: userDataCopy)
        tmpSelectedLectures = TmpSelectedLectures(userdata: userDataCopy)
    }
    
//    func createWorkingCopy(){
//        userDataCopy = UserData.sharedInstance.copy() as! UserData
//        
//        tmpSelectedCourses = TmpSelectedCourses(userdata: userDataCopy)
//        tmpSelectedSemesters = TmpSelectedSemesters(userdata: userDataCopy)
//        tmpSelectedLectures = TmpSelectedLectures(userdata: userDataCopy)
//    }
    
    func commitChanges(){
        let oldLectures = SelectedLectures().getOneDimensionalList()
        let newLectures = tmpSelectedLectures.getOneDimensionalList()
        
        let added = addedLectures(oldLectures: oldLectures, newLectures: newLectures)
        userDataCopy.addedLectures = added
        
        let removed = removedLectures(oldLectures: oldLectures, newLectures: newLectures)
        userDataCopy.removedLectures = removed
        
        UserData.sharedInstance = userDataCopy.copy() as! UserData
    }
    
    // Liefert alles Lectures zurück die entfernt werden müssen
    func removedLectures(oldLectures: [Lecture], newLectures: [Lecture]) -> [Lecture] {
        var removedArray = [Lecture]()
        
        for lecture in oldLectures{
            var contains = false
            
            for newLecture in newLectures {
                if newLecture == lecture {
                    contains = true
                }
            }
            if(!contains){
                removedArray.append(lecture)
            }
        }
        return removedArray
    }
    
    // Liefert alles Lecutrues zurück die hinzugefügt werden müssen
    func addedLectures(oldLectures: [Lecture], newLectures: [Lecture]) -> [Lecture] {
        
        var addedArray = [Lecture]()
        
        for newLecture in newLectures{
            var contains = false
            
            for oldLecture in oldLectures {
                if oldLecture == newLecture {
                    contains = true
                }
            }
            if(!contains){
                addedArray.append(newLecture)
            }
        }
        
        return addedArray
    }
    
    // TODO
    public func updateCalendar() {
        _ = CalendarController().CalendarRoutine()
    }
    
    public func clearAllSettings() {
        tmpSelectedLectures.clear()
        // TODO einkommentieren wenn vorhanden
        //TmpSelectedSemesters().clear()
        //TmpSelectedCourses().clear()
    }
}
