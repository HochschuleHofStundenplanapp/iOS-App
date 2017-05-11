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
    
    var events: [EKEvent] = []
    var title = ""
    var iteration: iterationState = iterationState.weekly
    
    override init() {
        super.init()
        _ = createCalendar()
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
        _ = CalendarInterface.sharedInstance.removeCalendar()
    }
    
    // Erzeugt für alle übergebenen Lectures EkEvents und schreibt diese in den Kalender
    public func createAllEvents(lectures : [Lecture]){
        if (CalendarInterface.sharedInstance.isAuthorized()) {
            _ = CalendarInterface.sharedInstance.createCalenderIfNeeded()
            for lecture in lectures {
                createEventsForLecture(lecture: lecture)
            }
            CalendarInterface.sharedInstance.saveIDs()
        }
    }
    
    // Aktualisiert Werte aller Events
    public func updateAllEvents( changes : Changes){
        if (CalendarInterface.sharedInstance.isAuthorized()) {
            for change in changes.changes {
                let lecture = CalendarController().findLecture(change: change)
                let locationInfo = CalendarController().getLocationInfo(room: lecture.room)
                
                handleOldChange(change: change, lecture: lecture)
                
                let eventID = CalendarInterface.sharedInstance.findEventId(key: lecture.hashValue, title: change.name, startDate: change.combinedOldDate, onlyChanges: false)
                
                updateEvent(change: change, lecture: lecture, eventID : eventID, locationInfo : locationInfo)
            }
            CalendarInterface.sharedInstance.saveIDs()
        }
    }
    
    func handleOldChange(change : ChangedLecture, lecture : Lecture) {
        let changeEventID = CalendarInterface.sharedInstance.findEventId(key: lecture.hashValue, title: change.name, startDate: change.combinedOldDate, onlyChanges: true)
        if (changeEventID != "") {
            let oldEvent = CalendarInterface.sharedInstance.getEventWithEventID(eventID: changeEventID)
            oldEvent.title = change.name
            CalendarInterface.sharedInstance.updateEvent(eventID: changeEventID, updatedEvent: oldEvent, key: lecture.hashValue, lectureToChange: false)
        }
        
        if (change.combinedNewDate != nil) {
            let changeNewEventID = CalendarInterface.sharedInstance.findEventId(key: lecture.hashValue, title: change.name, startDate: change.combinedNewDate, onlyChanges: true)
            if (changeNewEventID != "") {
                if (CalendarInterface.sharedInstance.removeEvent(p_eventId: changeNewEventID)) {
                    CalendarInterface.sharedInstance.removeChangesID(eventID: changeNewEventID, key: lecture.hashValue)
                }
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
                    
                    // Wenn nicht bereits vorhanden
                    if (!CalendarInterface.sharedInstance.doEventExist(key: lecture.hashValue, startDate: change.combinedNewDate)) {
                        // Neues Event erstellen
                        let newEvent = fillNewEvent(oldEvent: oldEvent, lecture: lecture, change: change, locationInfo: locationInfo)
                        
                        // Neues Event erzeugen
                        CalendarInterface.sharedInstance.createEvent(p_event: newEvent, key: lecture.hashValue, isChanges: true)
                    }
                    
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
            
            CalendarInterface.sharedInstance.updateEvent(eventID: eventID, updatedEvent: oldEvent, key: lecture.hashValue, lectureToChange: true)
        }
    }
    
    func fillNewEvent(oldEvent : EKEvent, lecture : Lecture, change : ChangedLecture, locationInfo : String) -> EKEvent {
        let newEvent = EKEvent(eventStore: self.eventStore!)
        
        newEvent.title     = Constants.changesNew + change.name
        newEvent.notes     = oldEvent.notes
        newEvent.startDate = change.combinedNewDate
        newEvent.endDate   = (newEvent.startDate + 60 * 90)
        
        newEvent.location = locationInfo + " ," + lecture.room.appending(", \(change.newRoom)")
        
        newEvent.notes = lecture.comment + "  " + lecture.group
        
        return newEvent
    }
    
    // Entfernt mehrere übergebene Events
    public func removeAllEvents(lectures : [Lecture]){
        if (CalendarInterface.sharedInstance.isAuthorized()) {
            for lecture in lectures {
                
                let ids = CalendarInterface.sharedInstance.getIDFromDictonary(key: lecture.hashValue)
                
                if (!ids.isEmpty) {
                    for id in ids {
                        _ = CalendarInterface.sharedInstance.removeEvent(p_eventId: id, p_withNotes: true)
                    }
                    CalendarInterface.sharedInstance.removeIdsFromDictonary(key: lecture.hashValue)
                }
            }
            CalendarInterface.sharedInstance.saveIDs()
        }
    }
    
    // Erzeugt ein Event und schreibt es in den Kalender
    private func createEventsForLecture(lecture: Lecture) {
        lectureToEKEvent(lecture: lecture)
        
        for event in events {
            CalendarInterface.sharedInstance.createEvent(p_event: event, key: lecture.hashValue, isChanges: false)
        }
        
        // Events wieder leeren
        events = []
    }
    
    // Erzeugt ein EKEvent aus einer Lecture
    func lectureToEKEvent(lecture: Lecture) {
        title = lecture.name
        iteration = lecture.iteration
        
        if (lecture.iteration == iterationState.calendarWeeks) {
            handleCalendarWeeks(lecture: lecture)
            return
        } else if (lecture.iteration == iterationState.notParsable) {
            handleNotParsable()
        }
        
        createEvents(lecture: lecture)
    }
    
    private func handleNotParsable() {
        // Nicht parsbar, deswegen Standard 7 nehmen
        title = "[Kommentar lesen] \(title)"
        iteration = iterationState.weekly
    }
    
    private func handleCalendarWeeks(lecture: Lecture){
        //Termine für vorgegebene Kalenderwochen
        
        //        iteration = iterationState.individualDate
        //
        //        for date in lecture.arrayWithDates {
        //            tmpStartdate = date
        //            createEvents(lecture: lecture)
        //        }
    }
    
    private func createEvents(lecture: Lecture) {
        var tmpStartdate = lecture.startdate
        repeat {
            let event       = EKEvent(eventStore: eventStore!)
            event.title     = title
            
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
            tmpStartdate = Calendar.current.date(byAdding: .day, value: iteration.rawValue, to: tmpStartdate)!
        } while (tmpStartdate.timeIntervalSince(lecture.enddate) <= 0 && iteration != iterationState.individualDate)
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
            
            if(!removedLectures.isEmpty) {
                CalendarController().removeAllEvents(lectures: removedLectures)
            }
            if(!addedLectures.isEmpty) {
                createAllEvents(lectures: addedLectures)
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
