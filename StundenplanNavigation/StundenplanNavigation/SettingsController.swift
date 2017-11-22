//
//  SettingsController.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 03.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit
import EventKit

class SettingsController: NSObject {
    
    var tmpSelectedCourses: TmpSelectedCourses
    var tmpSelectedSemesters: TmpSelectedSemesters
    var tmpSelectedLectures: TmpSelectedLectures
    var tmpSelectedSeason: String {
        didSet {
            userDataCopy.selectedSeason = tmpSelectedSeason
        }
    }
    var userDataCopy: UserData!
    
    lazy var calendarController = CalendarController()
    
    override init() {
        userDataCopy = UserData.sharedInstance.copy() as! UserData
        tmpSelectedCourses = TmpSelectedCourses(userdata: userDataCopy)
        tmpSelectedSemesters = TmpSelectedSemesters(userdata: userDataCopy)
        tmpSelectedLectures = TmpSelectedLectures(userdata: userDataCopy)
        tmpSelectedSeason = userDataCopy.selectedSeason
    }
    
    func set(season: String){
        tmpSelectedSeason = season
        clearAllSettings()
    }
    
    func setRemovedAndAddedLectures() {
        let oldLectures = SelectedLectures().getOneDimensionalList()
        let newLectures = tmpSelectedLectures.getOneDimensionalList()
        
        let added = addedLectures(oldLectures: oldLectures, newLectures: newLectures)
        userDataCopy.addedLectures = added
        
        let removed = removedLectures(oldLectures: oldLectures, newLectures: newLectures)
        userDataCopy.removedLectures = removed
    }
    
    func countChanges() -> Int{
        setRemovedAndAddedLectures()
        return userDataCopy.addedLectures.count + userDataCopy.removedLectures.count
    }
    
    func commitChanges(){
        setRemovedAndAddedLectures()
        
        if(UserData.sharedInstance.callenderSync == true){
            userDataCopy.callenderSync = true
        }
        if(UserData.sharedInstance.calendarIdentifier != nil){
            userDataCopy.calendarIdentifier = UserData.sharedInstance.calendarIdentifier
        }
        
        UserData.sharedInstance = userDataCopy.copy() as! UserData
        DataObjectPersistency().saveDataObject(items: UserData.sharedInstance)
        
        updateCalendar()
        
        UserData.sharedInstance.addedLectures = []
        UserData.sharedInstance.removedLectures = []
        UserData.sharedInstance.savedSplusnames = []
        UserData.sharedInstance.oldChanges = []
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
    
    public func updateCalendar() {
        if UserData.sharedInstance.callenderSync {
            if !calendarController.updateIOSCalendar() {
                NotificationCenter.default.post(name: .showHasNoAccessAlert , object: nil)
            }
        }
    }
    
    public func clearAllSettings() {
        tmpSelectedCourses.clear()
        tmpSelectedSemesters.clear()
        tmpSelectedLectures.clear()
    }
    
    public func startCalendarSync() {
        calendarController.createCalendar()
        
        switch calendarController.getAuthorizationStatus() {
        case EKAuthorizationStatus.denied:
            NotificationCenter.default.post(name: .showHasNoAccessAlert , object: nil)
            UserData.sharedInstance.callenderSync = false
        default:
            UserData.sharedInstance.callenderSync = true
        }
        DataObjectPersistency().saveDataObject(items: UserData.sharedInstance)
    }
    
    public func stopCalendarSync() {
        calendarController.removeCalendar()
        UserData.sharedInstance.callenderSync = false
        DataObjectPersistency().saveDataObject(items: UserData.sharedInstance)
    }
    
    public func handleCalendarSync() {
        if (UserData.sharedInstance.callenderSync) {
            UserData.sharedInstance.callenderSync = true
            calendarController.createCalendar()
        } else {
            UserData.sharedInstance.callenderSync = false
        }
    }
}

