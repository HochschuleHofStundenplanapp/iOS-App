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
    var notes = ""
    var iteration: iterationState = iterationState.weekly
    
    override init() {
        super.init()
        _ = createCalendar()
    }
    
    public func createCalendar() -> EKAuthorizationStatus {
        if(CalendarInterface.sharedInstance.isAuthorized()){
            if(CalendarInterface.sharedInstance.createCalenderIfNeeded() == true) {
                createAllEvents(lectures: SelectedLectures().getOneDimensionalList())
            }
            return EKAuthorizationStatus.authorized
        } else {
            if (EKEventStore.authorizationStatus(for: EKEntityType.event) == EKAuthorizationStatus.notDetermined) {
                return EKAuthorizationStatus.notDetermined
            }
            return EKAuthorizationStatus.denied
        }
    }
    
	// TODO kann wahrscheinlich gelöscht werden
    public func calendarAuthorizationStatus() -> Bool {
        if CalendarInterface.sharedInstance.isAuthorized() {
            return true
        } else {
            return false
        }
    }
    
    public func removeCalendar() {
		if(CalendarInterface.sharedInstance.isAuthorized()) {
			_ = CalendarInterface.sharedInstance.removeCalendar()
		}
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
    public func updateAllEvents (changes : [ChangedLecture]) {
        if (CalendarInterface.sharedInstance.isAuthorized()) {
            for change in changes {
                if let lecture = CalendarController().findLecture(change: change) {
                    let locationInfo = CalendarController().getLocationInfo(room: lecture.room)
                    
                    handleOldChange(change: change, lecture: lecture)
                    
                    let eventID = CalendarInterface.sharedInstance.findEventId(key: lecture.key, title: change.name, startDate: change.combinedOldDate, onlyChanges: false)
                    
                    updateEvent(change: change, lecture: lecture, eventID : eventID, locationInfo : locationInfo)
                } else {
                    //TODO muss hier noch was passieren?
                    print("lecture not found")
                }
            }
            CalendarInterface.sharedInstance.saveIDs()
        }
    }
    
    func handleOldChange(change : ChangedLecture, lecture : Lecture) {
        let changeEventID = CalendarInterface.sharedInstance.findEventId(key: lecture.key, title: change.name, startDate: change.combinedOldDate, onlyChanges: true)
        if (changeEventID != "") {
            let oldEvent = CalendarInterface.sharedInstance.getEventWithEventID(eventID: changeEventID)
            if(oldEvent != nil){
                oldEvent?.title = change.name
                CalendarInterface.sharedInstance.updateEvent(eventID: changeEventID, updatedEvent: oldEvent!, key: lecture.key, lectureToChange: false)
            }
        }
        
        if (change.combinedNewDate != nil) {
            let changeNewEventID = CalendarInterface.sharedInstance.findEventId(key: lecture.key, title: change.name, startDate: change.combinedNewDate, onlyChanges: true)
            if (changeNewEventID != "") {
                if (CalendarInterface.sharedInstance.removeEvent(p_eventId: changeNewEventID)) {
                    CalendarInterface.sharedInstance.removeChangesID(eventID: changeNewEventID, key: lecture.key)
                }
            }
        }
    }
    
    // Aktualisiert Werte des übergebenem Events
    func updateEvent(change : ChangedLecture, lecture : Lecture, eventID : String, locationInfo : String) {
        
        let oldEvent = CalendarInterface.sharedInstance.getEventWithEventID(eventID: eventID)
        
        if(oldEvent != nil){
            
            if (oldEvent?.title != "") {
                if (change.newDay != "") {
                    if (oldEvent?.startDate != change.combinedNewDate) {
                        // Datum geändert
                        
                        // Wenn nicht bereits vorhanden
                        if (!CalendarInterface.sharedInstance.doEventExist(key: lecture.key, startDate: change.combinedNewDate)) {
                            // Neues Event erstellen
                            let newEvent = fillNewChangeEvent(oldEvent: oldEvent!, lecture: lecture, change: change, locationInfo: locationInfo)
                            
                            // Neues Event erzeugen
                            CalendarInterface.sharedInstance.createEvent(p_event: newEvent, key: lecture.key, isChanges: true)
                        }
                        
                        // Daten bei altem Event ändern
                        oldEvent?.title    = Constants.changesChanged + change.name
                        oldEvent?.location = nil
                        oldEvent?.alarms   = []
                    } else {
                        // Raum geändert
                        oldEvent?.title     = Constants.changesRoomChanged + change.name
                        
                        oldEvent?.location = locationInfo.appending(", \(change.newRoom)")
                        
                    }
                } else {
                    // Fällt aus
                    oldEvent?.title    = Constants.changesFailed + change.name
                    oldEvent?.location = nil
                    oldEvent?.alarms   = []
                }
                
                CalendarInterface.sharedInstance.updateEvent(eventID: eventID, updatedEvent: oldEvent!, key: lecture.key, lectureToChange: true)
            }
        }
    }
    
    func fillNewChangeEvent(oldEvent : EKEvent, lecture : Lecture, change : ChangedLecture, locationInfo : String) -> EKEvent {
        let newEvent = EKEvent(eventStore: self.eventStore!)
        
        newEvent.title     = Constants.changesNew + change.name
        //newEvent.notes     = oldEvent.notes
        newEvent.startDate = change.combinedNewDate
        newEvent.endDate   = (newEvent.startDate + 60 * 90)
        
        newEvent.location = locationInfo + ", " + change.newRoom
        
        newEvent.notes = lecture.comment + "  " + lecture.group
        
        return newEvent
    }
    
    // Entfernt mehrere übergebene Events
    public func removeAllEvents(lectures : [Lecture]){
        if (CalendarInterface.sharedInstance.isAuthorized()) {
            for lecture in lectures {
                
                let ids = CalendarInterface.sharedInstance.getIDFromDictonary(key: lecture.key)
                
                if (!ids.isEmpty) {
                    for id in ids {
                        _ = CalendarInterface.sharedInstance.removeEvent(p_eventId: id, p_withNotes: true)
                    }
                    CalendarInterface.sharedInstance.removeIdsFromDictonary(key: lecture.key)
                }
            }
            CalendarInterface.sharedInstance.saveIDs()
        }
    }
    
    // Erzeugt ein Event und schreibt es in den Kalender
    private func createEventsForLecture(lecture: Lecture) {
        lectureToEKEvent(lecture: lecture)
        
        for event in events {
            CalendarInterface.sharedInstance.createEvent(p_event: event, key: lecture.key, isChanges: false)
        }
        
        // Events wieder leeren
        events = []
    }
    
    // Erzeugt ein EKEvent aus einer Lecture
    private func lectureToEKEvent(lecture: Lecture) {
        //print("Setze title kalender \(lecture.calendarName) - alt war \(lecture.name)")
        title = lecture.calendarName
        
        iteration = lecture.iteration
        notes = lecture.comment + "  " + lecture.group
        
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
        title = Constants.readNotes + "" + title
        notes = Constants.noteNotParsable + "" + notes
        iteration = iterationState.weekly
    }
    
    private func handleCalendarWeeks(lecture: Lecture){
        //Termine für vorgegebene Kalenderwochen
        
        iteration = iterationState.individualDate
        
        for date in lecture.kwDates {
            lecture.startdate = date
            createEvents(lecture: lecture)
        }
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
            
            event.location = CalendarController().getLocationInfo(room: lecture.room) + ", " + lecture.room
            
            event.notes = notes
            
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
    public func findLecture(change : ChangedLecture) -> Lecture? {
        var result : Lecture? = nil
        
        for lecture in SelectedLectures().getOneDimensionalList() {
            if(lecture.isEqual(to: change)){
                result = lecture
            }
        }
        return result
    }
    
    public func CalendarRoutine() -> Bool{
        if(!CalendarInterface.sharedInstance.isAuthorized()) {
            UserData.sharedInstance.callenderSync = false
            return false
        }
        
        if(!UserData.sharedInstance.removedLectures.isEmpty) {
            CalendarController().removeAllEvents(lectures: UserData.sharedInstance.removedLectures)
        }
        if(!UserData.sharedInstance.addedLectures.isEmpty) {
            createAllEvents(lectures: UserData.sharedInstance.addedLectures)
        }
        return true
    }
    
    
    // Gibt den Locaitonnamen zurück
    public func getLocationInfo( room : String) -> String {
        if(room.characters.count > 3 ){
            let index = room.index(room.startIndex, offsetBy : 4)
            let locationString = room.substring(to: index)
            
            if(locationString == Constants.locationInfoMueb){
                return Constants.locationHuchschuleMuenchberg
            } else {
                return Constants.locationHochschuleHof
            }
        } else {
        return "Kein Ort vorhanden"
        }
    }
    
    func callUpdateAllEvents( changes : [ChangedLecture]){
        updateAllEvents(changes: changes)
    }
    
}
