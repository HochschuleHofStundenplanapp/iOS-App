//
//  ChangesController.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 13.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit
import StundenplanFramework

class ChangesController: NSObject {

    func compareChanges(oldChanges: [ChangedLecture], newChanges: [ChangedLecture]) -> [ChangedLecture]{
        
        var resultChanges = [ChangedLecture]()
        
        for newChange in newChanges{
            var isNewChangedLecture = true
            for oldChange in oldChanges{
                if compareChangesDetails(chLecture: newChange, chLecture2: oldChange){
                    isNewChangedLecture = false
                }
            }
            if isNewChangedLecture{
                resultChanges.append(newChange)
            }
        }
        
        return resultChanges
        
    }
    private func compareChangesDetails(chLecture : ChangedLecture, chLecture2 : ChangedLecture) -> Bool {
        
        return (chLecture2.name == chLecture.name) && (chLecture2.oldRoom == chLecture.oldRoom) && (chLecture2.oldDay == chLecture.oldDay) && (chLecture2.newTime == chLecture.newTime) && (chLecture2.group == chLecture.group)
    }
    
    func determineTodaysChanges(changedLectures: [ChangedLecture]) -> [ChangedLecture]{
        
        let date = Date()
        var todayChanges = [ChangedLecture]()
        
        for change in changedLectures{
            let calendar = Calendar.current
            let currentMonth = calendar.component(.month, from: date)
            let currentDay = calendar.component(.day, from: date)
            
            let oldMonth = calendar.component(.month, from: change.oldDate)
            let oldDay = calendar.component(.day, from: change.oldDate)
            
            if currentMonth == oldMonth && currentDay == oldDay {
                todayChanges.append(change)
            }
        }
        
        return todayChanges
    }
    
}
