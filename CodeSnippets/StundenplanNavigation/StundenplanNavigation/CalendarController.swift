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
    
    // Gibt den Locaitonnamen zurück
    func getLocationInfo( room : String) -> String {
        
        let index = room.index(room.startIndex, offsetBy : 4)
        let locationString = room.substring(to: index)
        
        if(locationString == Constants.locationInfoMueb){
            return Constants.locationHuchschuleMuenchberg
        } else {
            return Constants.locationHochschuleHof
        }
    }
    
    // Erzeugt ein Event und schreibt es in den Kalender
    func createEventsForLecture(lecture: Lecture, calendar : EKCalendar, eventStore : EKEventStore ) {
        let events = lectureToEKEventCreate(lecture: lecture, eventStore: eventStore)
        
        for event in events {
            event.calendar  = calendar
            
            do {
                try eventStore.save(event, span: .thisEvent)
            } catch {
                print("TODO Fehlermeldung \n KalenderAPI create CREATEEVENTSFORLECTURE")
            }
            
            lecture.eventIDs.append(event.eventIdentifier)
        }
    }
    
    // Erzeugt ein EKEvent aus einer Lecture
    func lectureToEKEventCreate(lecture: Lecture , eventStore : EKEventStore) -> [EKEvent] {
        var tmpStartdate = lecture.startdate
        var events = [EKEvent]()
        
        repeat {
            let event       = EKEvent(eventStore: eventStore)
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
            tmpStartdate = Calendar.current.date(byAdding: .day, value: 7, to: tmpStartdate)!
        } while (tmpStartdate.timeIntervalSince(lecture.enddate) <= 0)
        
        return events
    }
    
    
    // Schreibt übergebene Events in den Kalender
    func createEvent(p_event: EKEvent, lecture : Lecture, eventStore : EKEventStore , calendar : EKCalendar){
        let event       = EKEvent(eventStore: eventStore)
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
        
        event.calendar  = calendar
        
        do {
            try eventStore.save(event, span: .thisEvent)
        } catch {
            print("Fehler beim erzeugen eines Events und beim Eintragen des Events")
        }
        
        lecture.eventIDs.append(event.eventIdentifier)
    }
    
    // ID eines Events im Kalender wird gesucht und zurückgegeben
    func findEventId(lecture: Lecture, change: ChangedLecture, eventStore : EKEventStore) -> String{
        
        var result = ""
        for id in lecture.eventIDs {
            let event = eventStore.event(withIdentifier: id)
            if(event?.title == change.name && event?.startDate == change.oldDate ){
                result = id
            }
        }
        return result
    }
    
    // Findet eine Lecutre anhand des Hashes
    func findLecture(change : ChangedLecture) -> Lecture {
        var result : Lecture? = nil
        let changeHashValue = "\(change.name)\(change.oldRoom)\(change.oldDay)\(change.oldTime)".hashValue
        
        for lecture in Settings.sharedInstance.savedSchedule.selLectures {
            if(lecture.hashValue == changeHashValue){
                result = lecture
            }
        }
        return result!
    }
    
    // Entfernt mehrere übergebene Events
    func removeAllEvents(lectures : [Lecture]){
        if (CalendarInterface.sharedInstance.checkCalendarAuthorizationStatus()) {
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
    
    // Aktualisiert Werte aller Events
    func updateAllEvents( changes : Changes){
        if (CalendarInterface.sharedInstance.checkCalendarAuthorizationStatus()) {
            for change in changes.changes {
                CalendarInterface.sharedInstance.updateEvent(change: change)
            }
        }
    }
}
