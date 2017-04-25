//
//  CalendarController.swift
//  StundenplanNavigation
//
//  Created by Stefan Scharrer on 06.04.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit
import EventKit

class CalendarController: NSObject {
    
    var eventStore = CalendarInterface.sharedInstance.eventStore
    
    override init() {
        super.init()
        createCalendar()
    }
    
    public func createCalendar() -> Bool {
        if(CalendarInterface.sharedInstance.isAuthorized()){
            if(CalendarInterface.sharedInstance.createCalenderIfNeeded() == true) {
                createAllEvents(lectures: Settings.sharedInstance.savedSchedule.selLectures)
            }
            return true
        } else {
            if (EKEventStore.authorizationStatus(for: EKEntityType.event) == EKAuthorizationStatus.notDetermined) {
                return true
            }
            return false
        }
    }
    
    public func removeCalendar() {
        CalendarInterface.sharedInstance.removeCalendar()
}
    
    // Erzeugt für alle übergebenen Lectures EkEvents und schreibt diese in den Kalender
    public func createAllEvents(lectures : [Lecture]){
        if (CalendarInterface.sharedInstance.isAuthorized()) {
            CalendarInterface.sharedInstance.createCalenderIfNeeded()
            for lecture in lectures {
                createEventsForLecture(lecture: lecture)
            }
        }
    }
    
    // Aktualisiert Werte aller Events
    public func updateAllEvents( changes : Changes){
        if (CalendarInterface.sharedInstance.isAuthorized()) {
            for change in changes.changes {
                let lecture = CalendarController().findLecture(change: change)
                let eventID = CalendarController().findEventId(lecture: lecture, change: change)
                let locationInfo = CalendarController().getLocationInfo(room: lecture.room)
                updateEvent(change: change, lecture: lecture, eventID : eventID, locationInfo : locationInfo)
            }
        }
    }
    
    // Aktualisiert Werte des übergebenem Events
    func updateEvent(change : ChangedLecture, lecture : Lecture, eventID : String, locationInfo : String) {
        
        let oldEvent = CalendarInterface.sharedInstance.getEventWithEventID(eventID: eventID)
        
        if (oldEvent.title != "") {
            if (change.newDay != "") {
                if (oldEvent.startDate != change.combinedNewDate) {
                    // Datum geändert
                    
                    // Neues Event erstellen
                    let newEvent = EKEvent(eventStore: self.eventStore!)
                    
                    newEvent.title     = Constants.changesNew + change.name
                    newEvent.notes     = oldEvent.notes
                    newEvent.startDate = change.combinedNewDate
                    newEvent.endDate   = (newEvent.startDate + 60 * 90)
                    
                    newEvent.location = locationInfo + " ," + lecture.room.appending(", \(change.newRoom)")
                    
                    newEvent.notes = lecture.comment + "  " + lecture.group
                    
                    // Neues Event erzeugen
                    CalendarInterface.sharedInstance.createEvent(p_event: newEvent , lecture: lecture)
                    
                    // Daten bei altem Event ändern
                    oldEvent.title    = Constants.changesChanged + change.name
                    oldEvent.location = nil
                    oldEvent.alarms   = []
                } else {
                    // Raum geändert
                    oldEvent.title     = Constants.changesRoomChanged + change.name
                    
                    oldEvent.location = locationInfo.appending(", \(change.newRoom)")
                    
                }
            } else {
                // Fällt aus
                oldEvent.title    = Constants.changesFailed + change.name
                oldEvent.location = nil
                oldEvent.alarms   = []
            }
        
            CalendarInterface.sharedInstance.updateEvent(eventID: eventID, updatedEvent: oldEvent)
        }
    }
    
    // Entfernt mehrere übergebene Events
    public func removeAllEvents(lectures : [Lecture]){
        if (CalendarInterface.sharedInstance.isAuthorized()) {
            for lecture in lectures {
                
                let ids = lecture.eventIDs
                
                if (!ids.isEmpty) {
                    for id in ids {
                        _ = CalendarInterface.sharedInstance.removeEvent(p_eventId: id, p_withNotes: true)
                    }
                }
            }
        }
    }
    
    // Erzeugt ein Event und schreibt es in den Kalender
    private func createEventsForLecture(lecture: Lecture) {
        let events = lectureToEKEventCreate(lecture: lecture)
        
        for event in events {
            event.calendar  = CalendarInterface.sharedInstance.calendar!
            
            do {
                try eventStore?.save(event, span: .thisEvent)
            } catch {
                print("TODO Fehlermeldung \n KalenderAPI create CREATEEVENTSFORLECTURE")
            }
            
            lecture.eventIDs.append(event.eventIdentifier)
        }
    }
    
    // Erzeugt ein EKEvent aus einer Lecture
    func lectureToEKEventCreate(lecture: Lecture) -> [EKEvent] {
        var tmpStartdate = lecture.startdate
        var events = [EKEvent]()
        
        repeat {
            let event       = EKEvent(eventStore: eventStore!)
            event.title     = lecture.name
            
            let tmpDate = tmpStartdate
            let hour = Calendar.current.component(.hour, from: lecture.startTime)
            let minutes = Calendar.current.component(.minute, from: lecture.startTime)
            
            event.startDate = tmpDate
            
            let endHour = Calendar.current.component(.hour, from: lecture.endTime)
            var duration = endHour - hour
            // Stunde in Minuten umrechnen
            duration = duration * 60
            // Minuten ausrechnen
            let endMinutes = Calendar.current.component(.minute, from: lecture.endTime)
            // Minuten hinzufügen oder abziehen
            duration = duration + (endMinutes - minutes)
            event.endDate   = Calendar.current.date(byAdding: .minute, value: duration, to: event.startDate)!
            
            event.location = CalendarController().getLocationInfo(room: lecture.room) + " ," + lecture.room
            
            event.notes = lecture.comment + "  " + lecture.group
            
            if (Constants.calendarAlarmOffset > 0) {
                var ekAlarms = [EKAlarm]()
                ekAlarms.append(EKAlarm(relativeOffset:-Constants.calendarAlarmOffset))
                event.alarms    = ekAlarms
            }
            
            events.append(event)
            
            // startdate für die nächste Vorlesung in einer Woche setzen
            tmpStartdate = Calendar.current.date(byAdding: .day, value: lecture.iteration, to: tmpStartdate)!
        } while (tmpStartdate.timeIntervalSince(lecture.enddate) <= 0)
        
        return events
    }
    
    // ID eines Events im Kalender wird gesucht und zurückgegeben
    public func findEventId(lecture: Lecture, change: ChangedLecture) -> String{
        
        var result = ""
        for id in lecture.eventIDs {
            let event = eventStore?.event(withIdentifier: id)
            if(event?.title == change.name && event?.startDate == change.combinedOldDate ){
                result = id
            }
        }
        return result
    }
    
    // Findet eine Lecutre anhand des Hashes
    public func findLecture(change : ChangedLecture) -> Lecture {
        var result : Lecture? = nil
        let changeHashValue = "\(change.name)\(change.oldRoom)\(change.oldDay)\(change.oldTime)".hashValue
        
        for lecture in Settings.sharedInstance.savedSchedule.selLectures {
            if(lecture.hashValue == changeHashValue){
                result = lecture
            }
        }
        return result!
    }
    
    public func CalendarRoutine() -> Bool{
        if(!CalendarInterface.sharedInstance.isAuthorized()) {
            Settings.sharedInstance.savedCalSync = false
            return false
        }
        
        if(CalendarInterface.sharedInstance.isAuthorized()) {
            // Liste der zu entferndenen Lectures
            let removedLectures = Settings.sharedInstance.tmpSchedule.removedLectures(oldSchedule: Settings.sharedInstance.savedSchedule)
            
            // Liste der zu hinzugefügten Lectures
            let addedLectures = Settings.sharedInstance.tmpSchedule.addedLectures(oldSchedule: Settings.sharedInstance.savedSchedule)
            
            if(!addedLectures.isEmpty) {
                createAllEvents(lectures: addedLectures)
            }
            if(!removedLectures.isEmpty) {
                CalendarController().removeAllEvents(lectures: removedLectures)
            }
            
            return true
        }
        
        return false
    }
    
    // Gibt den Locaitonnamen zurück
    public func getLocationInfo( room : String) -> String {
        let index = room.index(room.startIndex, offsetBy : 4)
        let locationString = room.substring(to: index)
        
        if(locationString == Constants.locationInfoMueb){
            return Constants.locationHuchschuleMuenchberg
        } else {
            return Constants.locationHochschuleHof
        }
    }
    
    func callUpdateAllEvents( changes : Changes){
        updateAllEvents(changes: changes)
    }
    
}
