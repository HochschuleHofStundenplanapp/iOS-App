//
//  CalendarInterface.swift
//  StundenplanNavigation
//
//  Created by Daniel on 13.12.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit
import EventKit

class CalendarInterface: NSObject {
    
    static var sharedInstance = CalendarInterface()
    
    
    // var lectureEKEventIdDictionary : [Lecture : [String]] = [:]
    
    var calendarTitle : String = "Hochschule Hof Stundenplan App"
    let eventStore = EKEventStore()
    var calendar : EKCalendar? = nil
    
    // Für Zukunft: Alarm setzen
    // Wenn alarmOffset größer 0 wird Alarm gesetzt
    let alarmOffset = 0.0
    
    let locationHochschule = "Hochschule Hof, Alfons-Goppel-Platz 1, 95028 Hof"
    
    override init() {
        super.init()
        
        if (checkAuthorizationStatus()) {
            var calendars = [EKCalendar]()
            calendars = self.eventStore.calendars(for: .event)
            for calendar in calendars {
                if(calendar.title == self.calendarTitle){
                    self.calendar = calendar
                    //!!! wieder raus vor commit
                    //removeCalendar()
                    //self.calendar = nil
                    break
                }
            }
            if(self.calendar == nil) {
                self.createCalender()
            }
        }
    }
    
    func removeCalendar() -> Bool {
        do {
            try self.eventStore.removeCalendar(self.calendar!, commit: true)
        } catch {
            print("can´t remove Calendar")
            return false
        }
        return true
    }
    
    private func createCalender(){
        if (checkAuthorizationStatus()) {
            let newCalendar = EKCalendar(for: .event, eventStore: self.eventStore)
            
            newCalendar.title = self.calendarTitle
            
            let sourcesInEventStore = self.eventStore.sources
            
            newCalendar.source = sourcesInEventStore.filter{
                (source: EKSource) -> Bool in
                source.sourceType.rawValue == EKSourceType.local.rawValue
                }.first!
            
            // Save the calendar using the Event Store instance
            do {
                try self.eventStore.saveCalendar(newCalendar, commit: true)
                self.calendar = newCalendar
            } catch {
                let alert = UIAlertController(title: "Calendar could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKAction)
            }
        }
    }
    
    private func checkAuthorizationStatus () -> Bool{
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            self.eventStore.requestAccess(to: .event, completion: {
                granted, error in
            })
        } else {
            return true
        }
        return false
    }
    
    //---
    
    //
    public func createAllEvents(lectures : [Lecture]){
        //print("\(lectures)" +  "Unser Zeugs " )
        for lecture in lectures{
            createEventsForLecture(lecture: lecture)
            // print("\(lecture)" +  "Unser Zeugs " )
        }
    }
    
    //Erzeugt Event und schreibt es in Kalender
    private func createEventsForLecture(lecture: Lecture) {
        if (checkAuthorizationStatus()) {
            // lecture to EKEvenet
            let events = lectureToEKEventCreate(lecture: lecture)
            
            for event in events {
                event.calendar  = self.calendar!
                
                do {
                    try self.eventStore.save(event, span: .thisEvent)
                } catch {
                    print("TODO Fehlermeldung \n KalenderAPI create CREATEEVENTSFORLECTURE")
                }
                
                //if(CalendarInterface.sharedInstance.lectureEKEventIdDictionary[lecture] == nil){
                 //   CalendarInterface.sharedInstance.lectureEKEventIdDictionary[lecture] = []
                //}
                
                //CalendarInterface.sharedInstance.lectureEKEventIdDictionary[lecture]?.append(event.eventIdentifier)
                lecture.eventIDs.append(event.eventIdentifier)
            }
        }
    }
    
    // Lecture to EKEvent
    func lectureToEKEventCreate(lecture: Lecture) -> [EKEvent] {
        var tmpStartdate = lecture.startdate
        // tmpStartdate.addingTimeInterval(lecture.starttime)
        var events = [EKEvent]()
        
        repeat {
            let event       = EKEvent(eventStore: self.eventStore)
            event.title     = lecture.name
            
            event.startDate = tmpStartdate.addingTimeInterval((lecture.starttime.timeIntervalSinceReferenceDate) + (60 * 60))
            event.endDate   = event.startDate.addingTimeInterval(60 * 90)
            event.location  = self.locationHochschule + ", " + lecture.room
            
            if (self.alarmOffset > 0) {
                var ekAlarms = [EKAlarm]()
                ekAlarms.append(EKAlarm(relativeOffset:-self.alarmOffset))
                event.alarms    = ekAlarms
            }
            
            events.append(event)
            tmpStartdate = tmpStartdate.addingTimeInterval(60.0 * 60.0 * 24 * 7)
        } while (tmpStartdate.timeIntervalSince(lecture.enddate) < 0)
        
        return events
    }
    
    //Erzeugt Event und schreibt es in Kalender
    private func createEvent(p_event: EKEvent) {
        if (checkAuthorizationStatus()) {
            
            let event       = EKEvent(eventStore: self.eventStore)
            event.title     = p_event.title
            event.notes     = p_event.notes
            event.startDate = p_event.startDate
            event.endDate   = p_event.endDate
            event.location  = p_event.location
            
            if (self.alarmOffset > 0) {
                var ekAlarms = [EKAlarm]()
                ekAlarms.append(EKAlarm(relativeOffset:-self.alarmOffset))
                event.alarms    = ekAlarms
            }
            
            event.calendar  = self.calendar!
            
            do {
                try self.eventStore.save(event, span: .thisEvent)
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
    
    // TODO lectures übergeben
    func updateAllEvents( lectures : [Lecture]){
        for lecture in lectures {
            // TODO richtige Werte
            //updateEvent(p_eventId: event.eventIdentifier, p_event: event, p_wasDeleted: false)
        }
    }
    
    // Lecture to EKEvent
//    func lectureToEKEventUpdate(lecture: Lecture) -> EKEvent {
//        var tmpStartdate = lecture.startdate
//        // tmpStartdate.addingTimeInterval(lecture.starttime)
//        var events = [EKEvent]()
//        
//        repeat {
//            let event       = EKEvent(eventStore: self.eventStore)
//            event.title     = lecture.name
//            
//            event.startDate = tmpStartdate.addingTimeInterval((lecture.starttime.timeIntervalSinceReferenceDate) + (60 * 60))
//            event.endDate   = event.startDate.addingTimeInterval(60 * 90)
//            event.location  = self.locationHochschule + ", " + lecture.room
//            
//            if (self.alarmOffset > 0) {
//                var ekAlarms = [EKAlarm]()
//                ekAlarms.append(EKAlarm(relativeOffset:-self.alarmOffset))
//                event.alarms    = ekAlarms
//            }
//            
//            events.append(event)
//            tmpStartdate = tmpStartdate.addingTimeInterval(60.0 * 60.0 * 24 * 7)
//        } while (tmpStartdate.timeIntervalSince(lecture.enddate) < 0)
//        
//        return events
//    }
    
    //Aktualisiert Werte des übergebenem Events
    private func updateEvent(p_eventId: String, p_event: EKEvent, p_wasDeleted: Bool) {
        if (checkAuthorizationStatus()) {
            let event = self.eventStore.event(withIdentifier: p_eventId)
            
            if((event) != nil) {
                if (p_wasDeleted == false) {
                    if (event?.startDate != p_event.startDate) {
                        let newEvent = EKEvent(eventStore: self.eventStore)
                        
                        newEvent.title     = "[NEU] " + p_event.title
                        newEvent.notes     = event?.notes
                        newEvent.startDate = p_event.startDate
                        newEvent.endDate   = p_event.endDate
                        newEvent.location  = p_event.location
                        newEvent.calendar  = self.calendar!
                        
                        createEvent(p_event: newEvent)
                        
                        event?.title    = "[Verschoben] " + p_event.title
                        event?.location = nil
                        event?.alarms   = []
                    } else {
                        event?.title     = "[Raumänderung] " + p_event.title
                        event?.location  = self.locationHochschule + ", " + p_event.location!
                    }
                } else {
                    event?.title     = "[Entfällt] " + p_event.title
                    event?.location = nil
                    event?.alarms   = []
                }
                
                event?.calendar  = self.calendar!;
                
                // andere Speichern Möglichkeit
                // [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
            }
            
            if((event) != nil) {
                do {
                    try self.eventStore.save(event!, span: .thisEvent)
                } catch {
                    print("TODO Fehlermeldung \n KalenderAPI update")
                }
            }
        }
    }
    
    // Entfernt mehrere übergebene Events
    func removeAllEvents(lectures : [Lecture]){
        for lecture in lectures {
            
            //let ids = lectureEKEventIdDictionary[lecture]
            //dump(lectureEKEventIdDictionary)
            
            let ids = lecture.eventIDs
            
            if (!ids.isEmpty) {
                for id in ids {
                    removeEvent(p_eventId: id)
                }
            }
        }
    }
    
    //Entfernt übergebenes Event
    private func removeEvent(p_eventId: String, p_withNotes: Bool?=false)-> Bool{
        if (checkAuthorizationStatus()) {
            let eventToRemove = self.eventStore.event(withIdentifier: p_eventId)
            if (eventToRemove != nil) {
                if (p_withNotes == false && eventToRemove?.notes != nil){ return false }
                
                do {
                    try self.eventStore.remove(eventToRemove!, span: .thisEvent)
                    return true
                } catch {
                    print("TODO removeEvent failed")
                }
            }
            return false
        }
        return false
    }
    
    //
    func getDayOfWeek(todayDate: NSDate)->Int? {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate as Date)
        let weekDay = myComponents.weekday
        return weekDay
    }
}



