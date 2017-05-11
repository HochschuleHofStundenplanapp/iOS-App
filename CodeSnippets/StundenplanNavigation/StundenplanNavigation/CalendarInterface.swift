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
    
    var idDictonary : CalendarEventIds!
    
    private override init() {
        super.init()
        eventStore = EKEventStore()
        idDictonary = DataObjectPersistency().loadIDList()
        
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
    func createEvent(p_event : EKEvent, key : Int, isChanges : Bool){
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
        
        if (isChanges) {
            addChangesID(eventID: event.eventIdentifier, key: key)
        } else {
            addLecturesID(eventID: event.eventIdentifier, key: key)
        }
    }
    
    func updateEvent(eventID : String, updatedEvent : EKEvent, key : Int, lectureToChange : Bool) {
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
        
        if (lectureToChange) {
            removeLecturesID(eventID: eventID, key: key)
            addChangesID(eventID: eventID, key: key)
        } else {
            removeChangesID(eventID: eventID, key: key)
            addLecturesID(eventID: eventID, key: key)
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
            let event = self.eventStore.event(withIdentifier: eventID)
            if (event != nil) {
                return event!
            } else {
                return EKEvent(eventStore: self.eventStore!)
            }
        } else {
            return EKEvent(eventStore: self.eventStore!)
        }
    }
    
    // ID eines Events im Kalender wird gesucht und zurückgegeben
    public func findEventId(key : Int, title : String, startDate : Date, onlyChanges : Bool) -> String{
        var result = ""
        if (!onlyChanges) {
            if let lectureIDs = idDictonary.lecturesEventIdDictonary[key] {
                for id in lectureIDs {
                    let event = CalendarInterface.sharedInstance.getEventWithEventID(eventID: id)
                    if (event.startDate == startDate) { // TODO Test  event.title == title &&
                        result = id
                    }
                }
            }
        }
        if let changesIDs = idDictonary.changesEventIdDictonary[key] {
            for id in changesIDs {
                let event = CalendarInterface.sharedInstance.getEventWithEventID(eventID: id)
                if (event.startDate == startDate) { // TODO Test  event.title == title &&
                    result = id
                }
            }
        }
        return result
    }
    
    public func doEventExist(key: Int, startDate: Date) -> Bool {
        if let lectureIDs = idDictonary.lecturesEventIdDictonary[key] {
            for id in lectureIDs {
                let event = CalendarInterface.sharedInstance.getEventWithEventID(eventID: id)
                if (event.startDate == startDate) { // TODO Test  event.title == title &&
                    return true
                }
            }
        }
        if let lectureIDs = idDictonary.changesEventIdDictonary[key] {
            for id in lectureIDs {
                let event = CalendarInterface.sharedInstance.getEventWithEventID(eventID: id)
                if (event.startDate == startDate) { // TODO Test  event.title == title &&
                    return true
                }
            }
        }
        return false
    }
    
    func addLecturesID(eventID : String, key : Int) {
        // Event ID zu Dictonary hinzufügen
        if var lectureIDs = idDictonary.lecturesEventIdDictonary[key] {
            lectureIDs.append(eventID)
            idDictonary.lecturesEventIdDictonary[key] = lectureIDs
        } else {
            idDictonary.lecturesEventIdDictonary[key] = [eventID]
        }
    }
    
    func addChangesID(eventID : String, key : Int) {
        // Event ID zu Dictonary hinzufügen
        if var lectureIDs = idDictonary.changesEventIdDictonary[key] {
            lectureIDs.append(eventID)
            idDictonary.changesEventIdDictonary[key] = lectureIDs
        } else {
            idDictonary.changesEventIdDictonary[key] = [eventID]
        }
    }
    
    func removeLecturesID(eventID : String, key : Int) {
        // Event ID zu Dictonary hinzufügen
        if var lectureIDs = idDictonary.lecturesEventIdDictonary[key] {
            let eventIDIndex = lectureIDs.index(of: eventID)
            lectureIDs.remove(at: eventIDIndex!)
            idDictonary.lecturesEventIdDictonary[key] = lectureIDs
        }
    }
    
    func removeChangesID(eventID : String, key : Int) {
        // Event ID zu Dictonary hinzufügen
        if var lectureIDs = idDictonary.changesEventIdDictonary[key] {
            let eventIDIndex = lectureIDs.index(of: eventID)
            lectureIDs.remove(at: eventIDIndex!)
            idDictonary.changesEventIdDictonary[key] = lectureIDs
        }
    }
    
    public func getIDFromDictonary(key: Int) -> [String] {
        var IDs = [String]()
        if let lectureIDs = idDictonary.lecturesEventIdDictonary[key] {
            for lecturesID in lectureIDs {
                IDs.append(lecturesID)
            }
        }
        if let changesIDs = idDictonary.changesEventIdDictonary[key] {
            for changesID in changesIDs {
                IDs.append(changesID)
            }
        }
        return IDs
    }
    
    public func removeIdsFromDictonary(key: Int) {
        if (idDictonary.lecturesEventIdDictonary[key] != nil) {
            idDictonary.lecturesEventIdDictonary[key] = []
        }
        if idDictonary.changesEventIdDictonary[key] != nil {
            idDictonary.changesEventIdDictonary[key] = []
        }
    }
    
    public func saveIDs() {
        DataObjectPersistency().saveIDList(items: idDictonary)
    }
}



