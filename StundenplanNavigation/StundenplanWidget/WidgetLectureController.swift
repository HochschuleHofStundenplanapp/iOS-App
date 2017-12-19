//
//  WidgetLectureController.swift
//  StundenplanWidget
//
//  Created by Bastian Kusserow on 01.12.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import Foundation
import StundenplanFramework

class WidgetLectureController {
    
    private let date = Date()
    private let calendar = Calendar.current
    var lecturesForCurrentDay : [Lecture] = []
    
    init(){
        let _ = getAllLecture()
    }
    
    func getAllLecture() -> [Lecture] {
       
        let day = getWeekday()
        lecturesForCurrentDay = DataObjectPersistency().loadDataObject().selectedSchedule.lectures[day]

        var resultLectures : [Lecture] = []
        
        let currentLecture = getCurrentLecture()
        
        if let aLecture = currentLecture {
            resultLectures.append(aLecture)
        }
        
        let upcoming = lecturesForCurrentDay.filter { (lecture) -> Bool in
            let dateTime = date.combineDateAndTime(date: date, time: lecture.startTime)
            return date.timeIntervalSinceReferenceDate <= dateTime.timeIntervalSinceReferenceDate
        }
        resultLectures+=upcoming
        
        if resultLectures.count < 2 {
            resultLectures+=getLecturesFor(nextWeekday(of: day))
        }
        
        return resultLectures
    }
    
    func getCurrentLecture() -> Lecture? {
        let now = Date()
        let currentLecture = lecturesForCurrentDay.first(where: { (lecture) -> Bool in
            let startTime = date.combineDateAndTime(date: now, time: lecture.startTime)
            let endTime = date.combineDateAndTime(date: now, time: lecture.endTime)
            let isInRange = now.timeIntervalSinceReferenceDate >= startTime.timeIntervalSinceReferenceDate && now.timeIntervalSinceReferenceDate <= endTime.timeIntervalSinceReferenceDate
            
            return isInRange
        })
        return currentLecture
    }
    
    
    func getLecturesFor(_ weekday: Int) -> [Lecture] {
        let aNextWeekday = nextWeekday(of: weekday)
        let lecturesOnWeekday = DataObjectPersistency().loadDataObject().selectedSchedule.lectures[weekday]
        if lecturesOnWeekday.count < 2{
            return lecturesOnWeekday + getLecturesFor(aNextWeekday)
        }else{
            return lecturesOnWeekday
        }
        
    }
    
    func nextWeekday(of weekday: Int) -> Int{
        if weekday == 6 {
            return 0
        }else{
            return weekday+1
        }
    }
    
    /*
        Calculates the current Weekday. Swift returns Weekday 1 for Sunday, to map it to the model we need Weekday 6. For the other Weekdays we need to subtract 2. Example: Weekday for Monday = 2 (Sunday is 1) -> Weekday-2 = 0 = Monday
    */
    func getWeekday() -> Int{
         let day = calendar.component(.weekday, from: date)

        if day == 1 {
            return 6
        }else {
            return day-2
        }
    }
    
    func isUpcomingLectureToday() -> Bool{
        let upcoming = lecturesForCurrentDay.filter { (lecture) -> Bool in
            let dateTime = date.combineDateAndTime(date: date, time: lecture.startTime)
            return date.timeIntervalSinceReferenceDate <= dateTime.timeIntervalSinceReferenceDate
        }
        if upcoming.count > 0 {
            return true
        }
        
        return false
    }
    
    
}










