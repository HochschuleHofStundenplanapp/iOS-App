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
    
    var lecturesIds : [Lecture : String] = [:]
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
    
    //Erzeugt Event und schreibt es in Kalender
    private func createEvent(p_event: EKEvent)-> String {
        if (authentificate()) {
            let event = EKEvent(eventStore: eventStore)
            
            event.title     = p_event.title
            // TODO Notes auch oder nicht?
            event.notes     = p_event.notes
            event.startDate = p_event.startDate
            event.endDate   = p_event.endDate
            event.location  = locationHochschule + ", " + p_event.location!
            
            
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
                print("TODO Fehlermeldung \n KalenderAPI create")
            }
            
            //p_event.eventIdentifier = event.eventIdentifier
            
            return event.eventIdentifier
        }
        return ""
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
    func createAllEvents( events : [EKEvent]){
        for event in events{
            createEvent(p_event: event)
        }
    }
    
    //
    func updateAllEvents( events : [EKEvent]){
        for event in events {
            // updateEvent(p_eventId: <#T##String#>, p_event: <#T##EKEvent#>, p_wasDeleted: <#T##Bool#>)
        }
    }
}
