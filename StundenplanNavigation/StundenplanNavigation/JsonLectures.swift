//
//  JsonLectures.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 09.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

//!!!!!!!!!!!!!Semestera anpassen!!!!!!!!!!!!!!!!!!

import UIKit
import StundenplanFramework

class JsonLectures: NSObject {
    fileprivate var pLectures : [Lecture]?
    fileprivate var semester: Semester!
    var fixedCalendarName : String = ""
    
    var lectures : [Lecture]? {
        get {
            return pLectures
        }
    }
    
    init? (data : Data, semester: Semester)
    {
        super.init()
        self.semester = semester
        let jsonT = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject
        guard let json = jsonT else {
            return nil
        }
        
        extractLectures(json)
    }
    
    fileprivate func extractLectures(_ json : AnyObject)
    {
        guard let jsonData = JSONData.fromObject(json), let allResults = jsonData["schedule"]?.array as [JSONData]! else
        {
            return
        }
        
        pLectures = []
        
        for i in allResults
        {
            let id = (i["id"]?.string)!
            let splusname = (i["splusname"]?.string)!
            var name = (i["label"]?.string)!
            let docent = (i["docent"]?.string)!
            let type = (i["type"]?.string)!
            let style = (i["style"]?.string)!
            let group = (i["group"]?.string)!
            let startt = (i["starttime"]?.string)!
            let endt = (i["endtime"]?.string)!
            let startd = (i["startdate"]?.string)!
            let endd = (i["enddate"]?.string)!
            let day = (i["day"]?.string)!
            let room = (i["room"]?.string)!
            let comment = (i["comment"]?.string)!
            
            let newId = Int(id)
            var dateArray : [Date] = []
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            dateFormatter.locale = Locale(identifier: "de_DE")
            
            var newStartDate = dateFormatter.date(from: startd + " " + startt)
            var newEndDate = dateFormatter.date(from: endd  + " " + endt)
        
            let ai = ArtificialIntelligence()
            
            let iteration = ai.iterationOfLecture(comment: comment, start: newStartDate!, end: newEndDate!)
            
            if iteration == iterationState.calendarWeeks {
                
                let calendarWeeks = ai.calendarWeekArray
                
                for cw in calendarWeeks {
                    let date = newStartDate?.calendarweekToDate(day: day, cw: cw, date: newStartDate!)
                    dateArray.append(date!)
                }
            }
            fixedCalendarName = name
            
            if iteration == iterationState.individualDate {
                let dateFormatterName = DateFormatter()
                dateFormatterName.dateFormat = "dd.MM."
                dateFormatterName.locale = Locale(identifier: "de_DE")
            
                name = "\(dateFormatterName.string(from: newStartDate!)) \(name)"
               
            }
            
            if iteration != iterationState.notParsable && iteration != iterationState.individualDate {

                let period = ai.checkPeriod(comment: comment)
                
                var aiStart = ai.checkStart(comment: comment)
                var aiEnd = ai.checkEnd(comment: comment)
                let season = UserData.sharedInstance.selectedSeason
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                dateFormatter.locale = Locale(identifier: "de_DE")
                
                if period != ("", ""){
                    aiStart = period.0
                    aiEnd = period.1
                }
                if aiStart != "" {
                    if Int(aiStart) != nil {
                        newStartDate = newStartDate?.calendarweekToDate(day: day, cw: Int(aiStart)!, date: newStartDate!)
                        
                        if iteration == iterationState.calendarWeeks {
                            dateArray.append(newStartDate!)
                        }
                    } else if dateFormatter.date(from: aiStart) != nil {
                        let tmpDate = dateFormatter.date(from: aiStart)!
                        let calendar = Calendar.current
                        let year = calendar.component(Calendar.Component.year, from: tmpDate)
                        // es gibt den einzelfall, das ein Jahr 0017 und nicht 2017 ist und somit die nachfolgende Berechnung ewig läuft...
                        // folgende Abfrage, gleicht das aus
                        if year < 100 {
                            let balancedDate = Calendar.current.date(byAdding: Calendar.Component.year, value: 2000, to: tmpDate, wrappingComponents: false)
                            newStartDate = newStartDate?.combineDateAndTime(date: balancedDate!, time: newStartDate!)
                        } else {
                            newStartDate = newStartDate?.combineDateAndTime(date: dateFormatter.date(from: aiStart)!, time: newStartDate!)
                        }
                        
                        if iteration == iterationState.calendarWeeks {
                            dateArray.append(newStartDate!)
                        }
                    }
                } else {
                    newStartDate = newStartDate?.startLecture(startDate: newStartDate!,weekdayString: day, semester: season)
                    if iteration == iterationState.twoWeeks {
                        newStartDate = newStartDate?.changeStartFromTwoWeekLecture(startDate: newStartDate!, semester: season)
                    }
                }
                
                if aiEnd != "" {
                    if Int(aiEnd) != nil {
                        newEndDate = newEndDate?.calendarweekToDate(day: day, cw: Int(aiEnd)!, date: newEndDate!)
                    } else if dateFormatter.date(from: aiEnd) != nil {
                        newEndDate = newEndDate?.combineDateAndTime(date: dateFormatter.date(from: aiEnd)!, time: newEndDate!)
                    }
                } else {
                    newEndDate = newEndDate?.endLecture(endDate: newEndDate!,weekdayString: day, semester: season)
                }
            }
            
            let lecture = Lecture(id: newId!, splusname: splusname, name: name, lecturer: docent, type: type, style: style, group: group, startdate: newStartDate!, enddate: newEndDate!, day: day, room: room, semester: self.semester, comment: comment, iteration: iteration, kwDates: dateArray,calendarName: self.fixedCalendarName)
          
            
            pLectures?.append(lecture)
        }
    }
}
