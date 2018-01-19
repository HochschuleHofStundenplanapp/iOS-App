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
    /**
    the current date.
    */
    fileprivate let date = Date()
    /**
     the current calendar.
     */
    fileprivate let calendar = Calendar.current
    /**
    the lectures for the current day.
    */
    fileprivate var lecturesForCurrentDay : [Lecture] = []
    fileprivate let dataPersistency : DataObjectPersistency!
    
    init(){
        dataPersistency = DataObjectPersistency()
        let _ = getAllLecture()
    }
    
    /**
     Looks up all lectures necessary for the widget (at least 2).
     - returns: Array of (lecture, day) tuples.
    */
    func getAllLecture() -> [(lecture:Lecture, day:Int)] {
        
        let day = getWeekday()
        lecturesForCurrentDay = dataPersistency.loadDataObject().selectedSchedule.lectures[day]

        var resultLectures : [(Lecture, Int)] = []
        
        let currentLecture = getCurrentLecture()
        
        if let aLecture = currentLecture {
            resultLectures.append((aLecture,day))
        }
        
        let upcoming = lecturesForCurrentDay.filter { (lecture) -> Bool in
            let dateTime = date.combineDateAndTime(date: date, time: lecture.startTime)
            return date.timeIntervalSinceReferenceDate <= dateTime.timeIntervalSinceReferenceDate
            }.map { (lecture) -> (Lecture, Int) in
                return (lecture,day)
        }
        resultLectures+=upcoming

        
        if resultLectures.count < 2 {
            //print("resultLectures < 2")
            resultLectures+=getLecturesFor(nextWeekday(of: day), day:day+1)
        }
        
        return resultLectures
    }
    /**
     Looks up if there is a Current Lecture.
     - returns: The current lecture or nil if currently there is no lecture.
    */
    fileprivate func getCurrentLecture() -> Lecture? {
        let now = Date()
        let currentLecture = lecturesForCurrentDay.first(where: { (lecture) -> Bool in
            let startTime = date.combineDateAndTime(date: now, time: lecture.startTime)
            let endTime = date.combineDateAndTime(date: now, time: lecture.endTime)
            let isInRange = now.timeIntervalSinceReferenceDate >= startTime.timeIntervalSinceReferenceDate && now.timeIntervalSinceReferenceDate <= endTime.timeIntervalSinceReferenceDate
            
            return isInRange
        })
        return currentLecture
    }
    
    var resultLectures = [(Lecture,Int)]()
    /**
     *  Looks up the Lectures for the passed weekday. The day parameter is nearly the same parameter as the
     *  weekday parameter, except that it can get greater than the weekday parameter (greater than 6).
     *  - parameter weekday: The weekday from which the lectures are to be calculated.
     *  - parameter day: **magic**
     * - returns: The lectures for the specified weekday(0-6). The day parameter indicates wether the next
     *  lecture is in the current week(0-6) or in a following week(greater than 6).
     */
    fileprivate func getLecturesFor(_ weekday: Int, day: Int) -> [(Lecture, Int)]
    {
        let aDay=day+1
        let aNextWeekday = nextWeekday(of: weekday)
        
        let lecturesOnWeekday = DataObjectPersistency().loadDataObject().selectedSchedule.lectures[weekday]
        
        if resultLectures.count < 2{
            return lecturesOnWeekday.map({ (lecture) -> (Lecture,Int) in
                resultLectures.append((lecture,aDay))
                return (lecture,aDay)
            }) + getLecturesFor(aNextWeekday,day:aDay)
        }else{
            return resultLectures
            }
        }
    
    /**
     Calculates the index of the next Weekday.
     - parameter weekday: The Weekday of wich the next Weekday should be calculated
     - returns: the next Weekday after the passed Weekday
     */
    fileprivate func nextWeekday(of weekday: Int) -> Int{
        if weekday == 6 {
            return 0
        }else{
            return weekday+1
        }
    }
    
    /**
     * Calculates the current Weekday. Swift returns Weekday 1 for Sunday, to map it to the model we
     * need Weekday 6. For the other Weekdays we need to subtract 2. Example: Weekday for Monday = 2
     * (Sunday is 1) -> Weekday-2 = 0 = Monday
     * - returns: The next Weekday
     */
    func getWeekday() -> Int{
        let day = calendar.component(.weekday, from: date)
        
        if day == 1 {
            return 6
        }else {
            return day-2
        }
    }
    
    /**
     * Calculates if there is a Lecture today.
     * - returns: True if there is a Lecture today. Otherwise false is returned.
     */
    func isUpcomingLectureToday() -> Bool{
        //Filters the lectures of the current day for a Lecture who's date is smaller then the current timestamp
        let upcoming = lecturesForCurrentDay.filter { (lecture) -> Bool in
            let dateTime = date.combineDateAndTime(date: date, time: lecture.startTime)
            return date.timeIntervalSinceReferenceDate >= dateTime.timeIntervalSinceReferenceDate
        }
        if upcoming.count > 0 {
            return true
        }
        
        return false
    }
    
    
}










