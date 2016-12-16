//
//  DateExtension.swift
//  StundenplanNavigation
//
//  Created by Paul Forstner on 14.12.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import Foundation


extension Date {
    
    //gibt SS oder WS zurück
    private func checkSemester() -> String{
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate)
        
        let startSummerString = "15.02.\(currentYear)"
        let endSummerString = "28.07.\(currentYear)"
        let startWinterString = "29.7.\(currentYear)"
        let endWinterString = "14.02.\(currentYear+1)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        let startSummer : Date = dateFormatter.date(from: startSummerString)!
        let endSummer : Date = dateFormatter.date(from: endSummerString)!
        let startWinter : Date = dateFormatter.date(from: startWinterString)!
        let endWinter : Date = dateFormatter.date(from: endWinterString)!
        
        if currentDate >= startSummer && currentDate <= endSummer{
            return "SS"
        }
        
        if currentDate >= startWinter && currentDate <= endWinter{
            return "WS"
        }
        
        return "SS"
    }
    
    //gibt Vorlesungsbeginn zurück
    private func startSemester(semester : String) -> Date{
        
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentDay = calendar.component(.day, from: currentDate)
        
        let startSummerComponents = DateComponents(year: currentYear, month: 3, day: 15)
        let startWinterComponents = DateComponents(year: currentYear, month: 10, day: 1)
        
        let startSummer : Date = calendar.date(from: startSummerComponents)!
        let startWinter : Date = calendar.date(from: startWinterComponents)!
        
        if semester == "SS" {
                
            if checkSemester() == "SS" && currentDate > startSummer {
                return currentDate
            }
                
            let difMonths = startSummerComponents.month! - currentMonth
            let difDays = startSummerComponents.day! - currentDay
                
            var newStartDate : Date = calendar.date(byAdding: .month, value: difMonths, to: currentDate)!
            newStartDate = calendar.date(byAdding: .day, value: difDays, to: newStartDate)!
            let startSemesterWeekday = calendar.component(.weekday, from: newStartDate)
            
            if checkSemester() != "SS" {
                newStartDate = calendar.date(byAdding: .year, value: -1, to: newStartDate)!
            }
            
            // Wenn der 15.3 ein Freitag/Samstag/Sonntag ist beginnt die Vorlesung am nächstfolgenden Montag
                
            if startSemesterWeekday == 6 {
                newStartDate = calendar.date(byAdding: .day, value: 3, to: newStartDate)!
            }
                
            if startSemesterWeekday == 7 {
                newStartDate = calendar.date(byAdding: .day, value: 2, to: newStartDate)!
            }
                
            if startSemesterWeekday == 1 {
                newStartDate = calendar.date(byAdding: .day, value: 1, to: newStartDate)!
            }
                
            return newStartDate
        }
        
        if semester == "WS"{
                
            if checkSemester() == "WS" && currentDate > startWinter {
                return currentDate
            }
        
            let difMonths = startWinterComponents.month! - currentMonth
            let difDays = startWinterComponents.day! - currentDay
                
            var newStartDate : Date = calendar.date(byAdding: .month, value: difMonths, to: currentDate)!
            newStartDate = calendar.date(byAdding: .day, value: difDays, to: newStartDate)!
            let startSemesterWeekday = calendar.component(.weekday, from: newStartDate)
                
            if checkSemester() != "WS" {
                newStartDate = calendar.date(byAdding: .year, value: -1, to: newStartDate)!
            }
                
            // Wenn der 1.10 ein Freitag/Samstag/Sonntag ist beginnt die Vorlesung am nächstfolgenden Montag
                
            if startSemesterWeekday == 6 {
                newStartDate = calendar.date(byAdding: .day, value: 3, to: newStartDate)!
            }
            
            if startSemesterWeekday == 7 {
                newStartDate = calendar.date(byAdding: .day, value: 2, to: newStartDate)!
            }
            
            if startSemesterWeekday == 1 {
                newStartDate = calendar.date(byAdding: .day, value: 1, to: newStartDate)!
            }
            
            return newStartDate
        }
        return currentDate
    }
    
    //gibt Vorlesungsende zurück
    public func endSemester(semester : String) -> Date{
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentDay = calendar.component(.day, from: currentDate)
        
        let endSummerComponents = DateComponents(year: currentYear, month: 7, day: 10)
        let endWinterComponents = DateComponents(year: currentYear+1, month: 1, day: 25)
        
        if semester == "SS" {
 
            let difMonths = endSummerComponents.month! - currentMonth
            let difDays = endSummerComponents.day! - currentDay
                
            var newEndDate : Date = calendar.date(byAdding: .month, value: difMonths, to: currentDate)!
            newEndDate = calendar.date(byAdding: .day, value: difDays, to: newEndDate)!
            
            if checkSemester() != "SS" {
                newEndDate = calendar.date(byAdding: .year, value: -1, to: newEndDate)!
            }
            
            let endSemesterWeekday = calendar.component(.weekday, from: newEndDate)
                
            // Wenn der 10.7 ein Samstag/Sonntag/Montag ist endet die Vorlesung am vorausgehenden Freitag
                
            if endSemesterWeekday == 7 {
                newEndDate = calendar.date(byAdding: .day, value: -1, to: newEndDate)!
            }
            
            if endSemesterWeekday == 1 {
                newEndDate = calendar.date(byAdding: .day, value: -2, to: newEndDate)!
            }
            
            if endSemesterWeekday == 2 {
                newEndDate = calendar.date(byAdding: .day, value: -3, to: newEndDate)!
            }
            return newEndDate
        }
        
        if checkSemester() == "WS"{
                
            let difMonths = endWinterComponents.month! - currentMonth
            let difDays = endWinterComponents.day! - currentDay
            
            var newEndDate : Date = calendar.date(byAdding: .month, value: difMonths, to: currentDate)!
            newEndDate = calendar.date(byAdding: .day, value: difDays, to: newEndDate)!
            newEndDate = calendar.date(byAdding: .year, value: 1, to: newEndDate)!
            let endSemesterWeekday = calendar.component(.weekday, from: newEndDate)
            
            if checkSemester() != "WS" {
                newEndDate = calendar.date(byAdding: .year, value: -1, to: newEndDate)!
            }
            
            // Wenn der 25.1 ein Samstag/Sonntag/Montag ist endet die Vorlesung am vorausgehenden Freitag
                
            if endSemesterWeekday == 7 {
                newEndDate = calendar.date(byAdding: .day, value: -1, to: newEndDate)!
            }
            
            if endSemesterWeekday == 1 {
                newEndDate = calendar.date(byAdding: .day, value: -2, to: newEndDate)!
            }
            
            if endSemesterWeekday == 2 {
                newEndDate = calendar.date(byAdding: .day, value: -3, to: newEndDate)!
            }
            
            return newEndDate
        }
        return currentDate
    }
    
    //gibt start einer einzelnen Vorlesung zurück
    public func startLecture(weekdayString : String, semester : String) -> Date{
        let weekDays = [("Montag", 2), ("Dienstag", 3), ("Mittwoch", 4), ("Donnerstag", 5), ("Freitag", 6), ("Samstag", 7)]
        let startSemesterDate = startSemester(semester: semester)
        let calendar = Calendar.current
        let startSemesterWeekday = calendar.component(.weekday, from: startSemesterDate)
        var lectureWeekday = 2
        var difDays = 0
        
        for i in weekDays {
            if i.0 == weekdayString {
                lectureWeekday = i.1
            }
        }
        
        if startSemesterWeekday < lectureWeekday {
            difDays = lectureWeekday - startSemesterWeekday
        }
        
        if startSemesterWeekday > lectureWeekday {
            difDays = lectureWeekday - startSemesterWeekday + 7
        }
        
        let newLectureStartDate : Date = calendar.date(byAdding: .day, value: difDays, to: startSemesterDate)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let finalStartString : String = dateFormatter.string(from: newLectureStartDate)
        let finalStartDate : Date = dateFormatter.date(from: finalStartString)!
        
        return finalStartDate
    }
    
    //gibt ende einer einzelnen Vorlesung zurück
    public func endLecture (weekdayString : String, semester : String) -> Date{
        let weekDays = [("Montag", 2), ("Dienstag", 3), ("Mittwoch", 4), ("Donnerstag", 5), ("Freitag", 6), ("Samstag", 7)]
        let endSemesterDate = endSemester(semester: semester)
        let calendar = Calendar.current
        let endSemesterWeekday = calendar.component(.weekday, from: endSemesterDate)
        var lectureWeekday = 6
        var difDays = 0
        
        for i in weekDays {
            if i.0 == weekdayString {
                lectureWeekday = i.1
            }
        }
        
        if endSemesterWeekday < lectureWeekday {
            difDays = lectureWeekday - endSemesterWeekday - 7
        }
        
        if endSemesterWeekday > lectureWeekday {
            difDays = lectureWeekday - endSemesterWeekday
        }
        
        let newLectureEndDate : Date = calendar.date(byAdding: .day, value: difDays, to: endSemesterDate)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
      
        let finalEndString : String = dateFormatter.string(from: newLectureEndDate)
        let finalEndDate : Date = dateFormatter.date(from: finalEndString)!
        
        return finalEndDate
    }
    
    public func changeTimeDate(date : Date) -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .year, value: 1, to: date)
        return newDate!
    }
}
