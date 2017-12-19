//
//  SelectedLectures.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 18.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

public class SelectedLectures: NSObject {
    
    fileprivate var userdata = UserData.sharedInstance
    
    public func numberOfEntries(for section : Int) -> Int{
        return userdata.selectedSchedule.daySize(at: section)
    }
    
    public func getElement(at indexPath : IndexPath) -> Lecture{
        return userdata.selectedSchedule.lecture(at: indexPath)
    }
    
    public func getOneDimensionalList() -> [Lecture]{
        let list = userdata.selectedSchedule.getOneDimensionalList()
        return list
    }
    
    public func sortLecturesForSchedule(){
        for i in 0..<userdata.selectedSchedule.lectures.count{
            userdata.selectedSchedule.lectures[i].sort(by: {$0.startTime < $1.startTime})
        }
    }
    
    public func contains(lecture: Lecture) -> Bool{
        return userdata.selectedSchedule.contains(lecture: lecture)
    }
}
