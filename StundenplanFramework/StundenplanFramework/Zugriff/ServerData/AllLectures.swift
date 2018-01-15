//
//  AllLectures.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 03.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

public class AllLectures: NSObject {

    fileprivate var serverData = ServerData.sharedInstance
    
    public func numberOfEntries(for section : Int) -> Int
    {
        return serverData.schedule.daySize(at: section)
    }
    
    public func getElement(at indexPath : IndexPath) -> Lecture
    {
        return serverData.schedule.lecture(at: indexPath)
    }
    
    public func getLectures() -> [[Lecture]] {
        return serverData.schedule.lectures
    }
    
    public func append(lectures : [Lecture]) {
        
        for lec in lectures{
            let dayIndex = Constants.weekDays.index(of: lec.day)!
            
            //Check lecture duplicates
            if !serverData.schedule.lectures[dayIndex].contains(lec) {
                serverData.schedule.add(lecture: lec, at: dayIndex)
            }
        }
    }
    
    public func sort(){
        for i in 0..<serverData.schedule.lectures.count{
            serverData.schedule.lectures[i].sort(by: {$0.startTime < $1.startTime})
        }
    }
    
    public func clear() {
        serverData.schedule.clear()
    }
}
