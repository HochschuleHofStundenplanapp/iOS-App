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
        
        //Semesterbeginn und Ende
        let startSummerString = "26.01.\(currentYear)"
        let endSummerString = "07.07.\(currentYear)"
        let startWinterString = "08.07.\(currentYear)"
        let endWinterString = "25.01.\(currentYear+1)"
        
        let beginningOfTheYearString = "01.01.\(currentYear)"
        let newEndWinterString = "25.01.\(currentYear)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        var startSummer : Date = dateFormatter.date(from: startSummerString)!
        var endSummer : Date = dateFormatter.date(from: endSummerString)!
        var startWinter : Date = dateFormatter.date(from: startWinterString)!
        var endWinter : Date = dateFormatter.date(from: endWinterString)!
        
        //Daten für Anfang des Jahres, da dann die Jahreszahl geändert werden muss
        let beginningOfTheYear : Date = dateFormatter.date(from: beginningOfTheYearString)!
        let newEndWinter : Date = dateFormatter.date(from: newEndWinterString)!
        
        //Wenn das akutelle Datum dem Anfang des Jahres bis zum Ende des Wintersemester entspricht, wird von jedem Datum das Jahr um 1 verringert
        if currentDate >= beginningOfTheYear && currentDate <= newEndWinter{
            startSummer = calendar.date(byAdding: .year, value: -1, to: startSummer)!
            endSummer = calendar.date(byAdding: .year, value: -1, to: endSummer)!
            startWinter = calendar.date(byAdding: .year, value: -1, to: startWinter)!
            endWinter = calendar.date(byAdding: .year, value: -1, to: endWinter)!
        }
        
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
    
        var startSummer : Date = calendar.date(from: startSummerComponents)!
        var startWinter : Date = calendar.date(from: startWinterComponents)!
        
        //Daten für Anfang des Jahres, da dann die Jahreszahl geändert werden muss
        let beginningOfTheYearComponents = DateComponents(year: currentYear, month: 1, day: 1)
        let endWinterSemesterComponents = DateComponents(year: currentYear, month: 2, day: 14)
        let beginningOfTheYear : Date = calendar.date(from: beginningOfTheYearComponents)!
        let endWinterSemester : Date = calendar.date(from: endWinterSemesterComponents)!
    
        if currentDate >= beginningOfTheYear && currentDate <= endWinterSemester {
            startSummer = calendar.date(byAdding: .year, value: -1, to: startSummer)!
            startWinter = calendar.date(byAdding: .year, value: -1, to: startWinter)!
        }
        
        if semester == "SS" {
                
//            if checkSemester() == "SS" && currentDate > startSummer {
//                return currentDate
//            }
            
            let difMonths = startSummerComponents.month! - currentMonth
            let difDays = startSummerComponents.day! - currentDay
                
            var newStartDate : Date = calendar.date(byAdding: .month, value: difMonths, to: currentDate)!
            newStartDate = calendar.date(byAdding: .day, value: difDays, to: newStartDate)!
            let startSemesterWeekday = calendar.component(.weekday, from: newStartDate)
            
            //wenn das ausgewählte Semester nicht dem aktuellen Semester entspricht, wird ein Jahr abgezogen
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
        
//            if checkSemester() == "WS" && currentDate > startWinter {
//                return currentDate
//            }
        
            let difMonths = startWinterComponents.month! - currentMonth
            let difDays = startWinterComponents.day! - currentDay
                
            var newStartDate : Date = calendar.date(byAdding: .month, value: difMonths, to: currentDate)!
            newStartDate = calendar.date(byAdding: .day, value: difDays, to: newStartDate)!
            let startSemesterWeekday = calendar.component(.weekday, from: newStartDate)
            
            //wenn das ausgewählte Semester nicht dem aktuellen Semester entspricht, wird ein Jahr abgezogen
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
        
        //Daten für Anfang des Jahres, da dann die Jahreszahl geändert werden muss
        let beginningOfTheYearComponents = DateComponents(year: currentYear, month: 1, day: 1)
        let endWinterSemesterComponents = DateComponents(year: currentYear, month: 2, day: 14)
        let beginningOfTheYear : Date = calendar.date(from: beginningOfTheYearComponents)!
        let endWinterSemester : Date = calendar.date(from: endWinterSemesterComponents)!
        
        if semester == "SS" {
 
            let difMonths = endSummerComponents.month! - currentMonth
            let difDays = endSummerComponents.day! - currentDay
                
            var newEndDate : Date = calendar.date(byAdding: .month, value: difMonths, to: currentDate)!
            newEndDate = calendar.date(byAdding: .day, value: difDays, to: newEndDate)!
            
            //wenn das ausgewählte Semester nicht dem aktuellen Semester entspricht, wird ein Jahr abgezogen
            if checkSemester() != "SS" {
                newEndDate = calendar.date(byAdding: .year, value: -1, to: newEndDate)!
            }
            
            if currentDate >= beginningOfTheYear && currentDate <= endWinterSemester {
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
            
            //wenn das ausgewählte Semester nicht dem aktuellen Semester entspricht, wird ein Jahr abgezogen
            if checkSemester() != "WS" {
                newEndDate = calendar.date(byAdding: .year, value: -1, to: newEndDate)!
            }
            
            if currentDate >= beginningOfTheYear && currentDate <= endWinterSemester {
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
    public func startLecture(startDate: Date, weekdayString : String, semester : String) -> Date{
        let weekDays = [("Montag", 2), ("Dienstag", 3), ("Mittwoch", 4), ("Donnerstag", 5), ("Freitag", 6), ("Samstag", 7)]
        let startSemesterDate = startSemester(semester: semester)
        let calendar = Calendar.current
        let startSemesterWeekday = calendar.component(.weekday, from: startSemesterDate)
        let hour = calendar.component(.hour, from: startDate)
        let minute = calendar.component(.minute, from: startDate)
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
        dateFormatter.locale = Locale(identifier: "de_DE")
        var finalStartString : String = dateFormatter.string(from: newLectureStartDate)
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "dd.MM.yy HH:mm"
        newDateFormatter.locale = Locale(identifier: "de_DE")
        
        finalStartString = finalStartString + " \(hour):\(minute)"
        
        let finalStartDate : Date = newDateFormatter.date(from: finalStartString)!
       
        return finalStartDate
    }
    
    //gibt ende einer einzelnen Vorlesung zurück
    public func endLecture (endDate: Date, weekdayString : String, semester : String) -> Date{
        let weekDays = [("Montag", 2), ("Dienstag", 3), ("Mittwoch", 4), ("Donnerstag", 5), ("Freitag", 6), ("Samstag", 7)]
        let endSemesterDate = endSemester(semester: semester)
        let calendar = Calendar.current
        let endSemesterWeekday = calendar.component(.weekday, from: endSemesterDate)
        let hour = calendar.component(.hour, from: endDate)
        let minute = calendar.component(.minute, from: endDate)
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
        dateFormatter.locale = Locale(identifier: "de_DE")
        var finalEndString : String = dateFormatter.string(from: newLectureEndDate)

        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "dd.MM.yy HH:mm"
        newDateFormatter.locale = Locale(identifier: "de_DE")
        
        finalEndString = finalEndString + " \(hour):\(minute)"

        let finalEndDate : Date = newDateFormatter.date(from: finalEndString)!

        return finalEndDate
    }
    
    public func changeTimeDate(date : Date) -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .year, value: 1, to: date)
        return newDate!
    }
}
