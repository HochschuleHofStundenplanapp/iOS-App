//
//  Schnittstelle Kalender.swift
//  EventDemo
//
//  Created by Jonas Beetz on 11.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit
import EventKit

class Schnittstelle_Kalender: NSObject {
    
    var lectureEKEventIdDictionary : [Lecture : [String]] = [:]
    // 0 ist leer weil beim Kalender Sonntag mit 1 beginnt
    var weekdays : [String] = ["","Sonntag","Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag"]
    var ScheduleCalendarID : String = ""
    var CalendarTitle : String = "Hochschule Hof Stundenplan App"
    let eventStore = EKEventStore()
    // Für Zukunft: Alarm setzen
    // Wenn alarmOffset größer 0 wird Alarm gesetzt
    let alarmOffset = 0.0
    let locationHochschule = "Hochschule Hof, Alfons-Goppel-Platz 1, 95028 Hof"
    
    override init() {
        super.init()
        if (authentificate()) {
            var calendars = [EKCalendar]()
            calendars = eventStore.calendars(for: .event)
            for calendar in calendars {
                if(calendar.title == CalendarTitle){
                    self.ScheduleCalendarID = calendar.calendarIdentifier
                    print ("id: ")
                    print (ScheduleCalendarID)
                    break
                }
            }
            if(ScheduleCalendarID == "") {
                self.createCalender()
            }
        }
    }
    
    func removeCalendar() -> Bool {
        do {
            try eventStore.removeCalendar(eventStore.calendar(withIdentifier: ScheduleCalendarID)!, commit: true)
        } catch {
            print("can´t remove Calendar")
            return false
        }
        return true
    }
    
    private func createCalender(){
        if (authentificate()) {
        let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
        
        newCalendar.title = CalendarTitle
        
        let sourcesInEventStore = eventStore.sources
        
        newCalendar.source = sourcesInEventStore.filter{
            (source: EKSource) -> Bool in
            source.sourceType.rawValue == EKSourceType.local.rawValue
            }.first!
        
        // Save the calendar using the Event Store instance
        do {
            try eventStore.saveCalendar(newCalendar, commit: true)
            ScheduleCalendarID = newCalendar.calendarIdentifier
            print(ScheduleCalendarID)
            // UserDefaults.standardUserDefaults.set(newCalendar.calendarIdentifier, forKey: ScheduleCalendarID)
        } catch {
            let alert = UIAlertController(title: "Calendar could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
        }
        }
    }
    
    private func authentificate () -> Bool{
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                print ("authentificate dialog")
            })
        } else {
            print ("authentificate")
            return true
        }
        return false
    }
    
    //---

    
    // Lecture to EKEvent
    func lectureToEKEvent(lecture: Lecture) -> [EKEvent] {
        var tmpStartdate = lecture.startdate
         // tmpStartdate.addingTimeInterval(lecture.starttime)
        var events = [EKEvent]()
        
        repeat {
            let event       = EKEvent(eventStore: eventStore)
            event.title     = lecture.name
            //var weekday   = weekdays[getDayOfWeek(todayDate: lecture.startdate as NSDate)!]
            //var tempDate  = NSDate(lecture.startdate)
            
            event.startDate = tmpStartdate.addingTimeInterval(lecture.starttime.timeIntervalSinceReferenceDate)
            event.endDate   = event.startDate.addingTimeInterval(60 * 90)
            event.location  = locationHochschule + ", " + lecture.room
            
            if (alarmOffset > 0) {
                var ekAlarms = [EKAlarm]()
                ekAlarms.append(EKAlarm(relativeOffset:-alarmOffset))
                event.alarms    = ekAlarms
            }
            
            events.append(event)
            tmpStartdate = tmpStartdate.addingTimeInterval(60.0 * 60.0 * 24 * 7)
        } while (tmpStartdate.timeIntervalSince(lecture.enddate) < 0)

        return events
    }

    //Erzeugt Event und schreibt es in Kalender
    private func createEvent(p_event: EKEvent) {
        if (authentificate()) {
            
            let event       = EKEvent(eventStore: eventStore)
            event.title     = p_event.title
            event.notes     = p_event.notes
            event.startDate = p_event.startDate
            event.endDate   = p_event.endDate
            event.location  = p_event.location
            
            if (alarmOffset > 0) {
                var ekAlarms = [EKAlarm]()
                ekAlarms.append(EKAlarm(relativeOffset:-alarmOffset))
                event.alarms    = ekAlarms
            }
            print ("ID")
            print (ScheduleCalendarID)
            event.calendar  = eventStore.calendar(withIdentifier: ScheduleCalendarID)!
            
            do {
                try eventStore.save(event, span: .thisEvent)
            } catch {
                print("TODO Fehlermeldung \n KalenderAPI create CREATE EVENT")
            }
            
            //p_event.eventIdentifier = event.eventIdentifier
            
            // noch überlegen wie wir die Event ID speichern
            /*if(lectureEKEventIdDictionary[lecture] == nil){
                lectureEKEventIdDictionary[lecture] = []
            }
            
            lectureEKEventIdDictionary[lecture]?.append(event.eventIdentifier)
            */
        }
    }
    
    //Erzeugt Event und schreibt es in Kalender
    private func createEventsForLecture(lecture: Lecture) {
        if (authentificate()) {
            // lecture to EKEvenet
            let events = lectureToEKEvent(lecture: lecture)
            
            for event in events {
                print ("ID")
                print (ScheduleCalendarID)
                event.calendar  = eventStore.calendar(withIdentifier: ScheduleCalendarID)!
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch {
                    print("TODO Fehlermeldung \n KalenderAPI create CREATEEVENTSFORLECTURE")
                }
                
                //p_event.eventIdentifier = event.eventIdentifier
                
                if(lectureEKEventIdDictionary[lecture] == nil){
                    lectureEKEventIdDictionary[lecture] = []
                }
                
                lectureEKEventIdDictionary[lecture]?.append(event.eventIdentifier)
            }
        }
    }
    
    //
    public func createAllEvents(lectures : [Lecture]){
        for lecture in lectures{
            createEventsForLecture(lecture: lecture)
        }
    }
    
    //Aktualisiert Werte des übergebenem Events
    private func updateEvent(p_eventId: String, p_event: EKEvent, p_wasDeleted: Bool) {
        if (authentificate()) {
            let event = eventStore.event(withIdentifier: p_eventId)
            
            if((event) != nil) {
                if (p_wasDeleted == false) {
                    if (event?.startDate != p_event.startDate) {
                        let newEvent = EKEvent(eventStore: eventStore)
                        
                        newEvent.title     = "[NEU] " + p_event.title
                        newEvent.notes     = event?.notes
                        newEvent.startDate = p_event.startDate
                        newEvent.endDate   = p_event.endDate
                        newEvent.location  = p_event.location
                        newEvent.calendar  = eventStore.defaultCalendarForNewEvents
                        
                        createEvent(p_event: newEvent)
                        
                        event?.title    = "[Verschoben] " + p_event.title
                        event?.location = nil
                        event?.alarms   = []
                    } else {
                        event?.title     = "[Raumänderung] " + p_event.title
                        event?.location  = locationHochschule + ", " + p_event.location!
                    }
                } else {
                    event?.title     = "[Entfällt] " + p_event.title
                    event?.location = nil
                    event?.alarms   = []
                }
                
                event?.calendar  = eventStore.calendar(withIdentifier: ScheduleCalendarID)!;
                
                // andere Speichern Möglichkeit
                // [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
            }
            
            if((event) != nil) {
                do {
                    try eventStore.save(event!, span: .thisEvent)
                } catch {
                    print("TODO Fehlermeldung \n KalenderAPI update")
                }
            }
        }
    }
    
    //Entfernt übergebenes Event
    private func removeEvent(p_eventId: String, p_withNotes: Bool?=false)-> Bool{
        if (authentificate()) {
            let eventToRemove = eventStore.event(withIdentifier: p_eventId)
            if (eventToRemove != nil) {
                if (p_withNotes == false && eventToRemove?.notes != nil){ return false }
                
                do {
                    try eventStore.remove(eventToRemove!, span: .thisEvent)
                    return true
                } catch {
                    print("Bad things happened")
                }
            }
            return false
        }
        return false
    }
    
    //
    func removeAllEvents( ids : [String]){
        for id in ids {
            removeEvent(p_eventId: id)
        }
    }
    
    //
    func updateAllEvents( events : [EKEvent]){
        for event in events {
            // TODO richtige Werte
            updateEvent(p_eventId: event.eventIdentifier, p_event: event, p_wasDeleted: false)
        }
    }
    
    //
    func getDayOfWeek(todayDate: NSDate)->Int? {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let myComponents = myCalendar.components(.weekday, from: todayDate as Date)
            let weekDay = myComponents.weekday
            return weekDay
    }
}


