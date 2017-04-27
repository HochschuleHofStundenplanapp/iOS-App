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
    
    var calendar : EKCalendar?
    var eventStore : EKEventStore!
    
    var eventIdDictonary : [Int:[String]] = [:]
    
    private override init() {
        super.init()
        eventStore = EKEventStore()
        if(!isAuthorized()){
            requestAccessToCalendar()
        } else {
            createCalenderIfNeeded()
        }
    }
    
    // ------ Kalendar-Methoden ------
    
    // Erstellen eines Kalenders
    private func createCalender(){
        let newCalendar = EKCalendar(for: .event, eventStore: self.eventStore)
        
        newCalendar.title = Constants.calendarTitle
        
        newCalendar.source = eventStore.defaultCalendarForNewEvents.source
        do {
            try self.eventStore.saveCalendar(newCalendar, commit: true)
            self.calendar = newCalendar
        } catch {
            print("Fehler bei create Calendar")
        }
    }
    
    public func createCalenderIfNeeded() -> Bool {
        if (!isAppCalenderAvailable()) {
            createCalender()
            return true
        }
        return false
    }
    
    // Check ob App-Calender schon vorhanden ist
    private func isAppCalenderAvailable() -> Bool
    {
        var calendars = [EKCalendar]()
        calendars = self.eventStore.calendars(for: .event)
        for calendar in calendars {
            if(calendar.title == Constants.calendarTitle){
                self.calendar = calendar
                return true
            }
        }
        return false
    }
    
    // Löschen eines Kalenders
    func removeCalendar() -> Bool {
        if(!isAuthorized())
        {return false}
        if(isAppCalenderAvailable()){
            do {
                try self.eventStore.removeCalendar(self.calendar!, commit: true)
            } catch {
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    // ------ Berechtigungs-Methoden ------
    
    // Berechtigungen für den Kalenderzugriff anfragen
    private func requestAccessToCalendar (){
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            self.eventStore.requestAccess(to: .event, completion: {
                granted, error in
                self.createCalenderIfNeeded()
            })
        }
    }
    
    public func isAuthorized() -> Bool {
        if (EKEventStore.authorizationStatus(for: EKEntityType.event) == EKAuthorizationStatus.authorized){
            return true
        } else {
            return false
        }
    }
    
    // ------ Eintrag-Methoden ------
    
    // Schreibt übergebene Events in den Kalender
    func createEvent(p_event : EKEvent, key : Int){
        let event       = EKEvent(eventStore: eventStore!)
        event.title     = p_event.title
        event.notes     = p_event.notes
        event.startDate = p_event.startDate
        event.endDate   = p_event.endDate
        event.location  = p_event.location
        
        if (Constants.calendarAlarmOffset > 0) {
            var ekAlarms = [EKAlarm]()
            ekAlarms.append(EKAlarm(relativeOffset:-Constants.calendarAlarmOffset))
            event.alarms    = ekAlarms
        }
        
        event.calendar  = calendar!
        
        do {
            try eventStore?.save(event, span: .thisEvent)
        } catch {
            print("Fehler beim erzeugen eines Events und beim Eintragen des Events")
        }
        
        // Event ID speichern
        if var lectureIDs = eventIdDictonary[key] {
            lectureIDs.append(event.eventIdentifier)
            eventIdDictonary[key] = lectureIDs
        } else {
            eventIdDictonary[key] = [event.eventIdentifier]
        }
    }
    
    func updateEvent(eventID : String, updatedEvent : EKEvent) {
        let event = getEventWithEventID(eventID: eventID)
        
        if (event.title != "") {
            event.title     = updatedEvent.title
            event.notes     = updatedEvent.notes
            event.startDate = updatedEvent.startDate
            event.endDate   = updatedEvent.endDate
            event.location  = updatedEvent.location
            event.calendar  = self.calendar!
        
            do {
                try self.eventStore.save(event, span: .thisEvent)
            } catch {
                print("Fehler beim Updaten eines Events")
            }
        }
    }
    
    //Entfernt übergebenes Event
    func removeEvent(p_eventId: String, p_withNotes: Bool?=false)-> Bool{
        let eventToRemove = self.eventStore.event(withIdentifier: p_eventId)
        if (eventToRemove != nil) {
            if (p_withNotes == false && eventToRemove?.notes != nil){ return false }
            do {
                try self.eventStore.remove(eventToRemove!, span: .thisEvent)
                return true
            } catch {
                print("Events konnte nicht gelöscht werden")
            }
        }
        return false
    }
    
    public func getEventWithEventID(eventID : String) -> EKEvent{
        if (eventID != "") {
            let event = self.eventStore.event(withIdentifier: eventID)!
            if (event != nil) {
                return event
            } else {
                return EKEvent(eventStore: self.eventStore!)
            }
        } else {
            return EKEvent(eventStore: self.eventStore!)
        }
    }
    
    // ID eines Events im Kalender wird gesucht und zurückgegeben
    public func findEventId(key: Int, title: String, startDate: Date) -> String{
        
        var result = ""
        if let lectureIDs = eventIdDictonary[key] {
            for id in lectureIDs {
                let event = CalendarInterface.sharedInstance.getEventWithEventID(eventID: id)
                if (event.title == title && event.startDate == startDate) {
                    result = id
                }
            }
        }
        return result
    }
    
    public func getIDFromDictonary(key: Int) -> [String] {
        if let lectureIDs = eventIdDictonary[key] {
            return lectureIDs
        } else {
            return []
        }
    }
    
    public func removeIdsFromDictonary(key: Int) {
        if (eventIdDictonary[key] != nil) {
            eventIdDictonary[key] = []
        }
    }
}



