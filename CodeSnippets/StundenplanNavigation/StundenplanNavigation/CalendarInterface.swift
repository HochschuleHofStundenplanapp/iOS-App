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
    
    var calendarTitle : String = "Hochschule Hof Stundenplan App"
    var calendar : EKCalendar? = nil
    var eventStore : EKEventStore!
    
    // Für Zukunft: Alarm setzen
    // Wenn alarmOffset größer 0 wird Alarm gesetzt
    let alarmOffset = 0.0
    
    let locationHochschuleHof = "Campus Hof, Alfons-Goppel-Platz 1, 95028 Hof"
    let locationHuchschuleMuenchberg = "Campus Münchberg, Kulmbacherstraße 76, 95213 Münchberg "
    
    
    override init() {
        super.init()
        eventStore = EKEventStore()
        if (checkCalendarAuthorizationStatus()) {
            var calendars = [EKCalendar]()
            calendars = self.eventStore.calendars(for: .event)
            for calendar in calendars {
                if(calendar.title == self.calendarTitle){
                    self.calendar = calendar
                    break
                }
            }
            if(self.calendar == nil) {
                self.createCalender()
            }
        }
    }
    
    // Löschen eines Kalenders
    func removeCalendar() -> Bool {
        do {
            try self.eventStore.removeCalendar(self.calendar!, commit: true)
        } catch {
            return false
        }
        return true
    }
    
    // Erstellen eines Kalenders
    private func createCalender(){
        let newCalendar = EKCalendar(for: .event, eventStore: self.eventStore)
        
        newCalendar.title = self.calendarTitle
        
        newCalendar.source = eventStore.defaultCalendarForNewEvents.source
        do {
            try self.eventStore.saveCalendar(newCalendar, commit: true)
            self.calendar = newCalendar
        } catch {
        }
        createAllEvents(lectures: Settings.sharedInstance.savedSchedule.selLectures)
    }
    
    //
    private func requestAccessToCalendar (){
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            self.eventStore.requestAccess(to: .event, completion: {
                granted, error in
            })
        }
    }
    
    // Abfrage der Kalenderberechtigungen
    public func checkCalendarAuthorizationStatus() -> Bool{
        var result = false
        var status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        repeat {
            status = EKEventStore.authorizationStatus(for: EKEntityType.event)
            switch (status) {
            case EKAuthorizationStatus.notDetermined:
                // This happens on first-run
                requestAccessToCalendar()
            // createCalender()
            case EKAuthorizationStatus.authorized:
                result = true
            // Things are in line with being able to show the calendars in the table view
            case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
                // We need to help them give us permission
                result = false
            }} while (status == EKAuthorizationStatus.notDetermined)
        return result
        
    }
    
    // Übergebene Events werden erstellt
    public func createAllEvents(lectures : [Lecture]){
        if (checkCalendarAuthorizationStatus()) {
            for lecture in lectures{
                createEventsForLecture(lecture: lecture)
            }
        }
    }
    
    //Erzeugt Event und schreibt es in Kalender
    private func createEventsForLecture(lecture: Lecture) {
        let events = lectureToEKEventCreate(lecture: lecture)
        
        for event in events {
            event.calendar  = self.calendar!
            
            do {
                try self.eventStore.save(event, span: .thisEvent)
            } catch {
                print("TODO Fehlermeldung \n KalenderAPI create CREATEEVENTSFORLECTURE")
            }
            
            lecture.eventIDs.append(event.eventIdentifier)
        }
    }
    
    // Umwandlung einer Lecture zu EKEvent
    func lectureToEKEventCreate(lecture: Lecture) -> [EKEvent] {
        var tmpStartdate = lecture.startdate
        var events = [EKEvent]()
        
        repeat {
            let event       = EKEvent(eventStore: self.eventStore)
            event.title     = lecture.name
            
            event.startDate = tmpStartdate.addingTimeInterval((lecture.starttime.timeIntervalSinceReferenceDate))
            event.endDate   = event.startDate.addingTimeInterval(60 * 90)
            
            
            let str = lecture.room
            let index = str.index(str.startIndex, offsetBy : 4)
            let sub = str.substring(to: index)
            
            if(sub == "Mueb"){
                event.location = self.locationHuchschuleMuenchberg + " ," + lecture.room
                
            } else {
                event.location = self.locationHochschuleHof + " ," + lecture.room
            }
            event.notes = lecture.comment + "  " + lecture.group
            
            if (self.alarmOffset > 0) {
                var ekAlarms = [EKAlarm]()
                ekAlarms.append(EKAlarm(relativeOffset:-self.alarmOffset))
                event.alarms    = ekAlarms
            }
            
            events.append(event)
            tmpStartdate = tmpStartdate.addingTimeInterval(60.0 * 60.0 * 24 * 7)
        } while (tmpStartdate.timeIntervalSince(lecture.enddate) <= 0)
        
        return events
    }
    
    // 
    private func combineDayAndTime(date : Date, time : Date) -> Date {
        return date.addingTimeInterval((time.timeIntervalSinceReferenceDate) + (60 * 60))
    }
    
    //Erzeugt Event und schreibt es in Kalender
    private func createEvent(p_event: EKEvent, lecture : Lecture){
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
            print("Fehler beim erzeugen eines Events und beim Eintragen des Events")
        }
        
        lecture.eventIDs.append(event.eventIdentifier)
    }
    
    // Übergebene Events updated/anpasst
    func updateAllEvents( changes : Changes){
        if (checkCalendarAuthorizationStatus()) {
            for change in changes.changes {
                updateEvent(change: change)
            }
        }
    }
    
    // Findet eine Lecutre anhand des Hashes
    private func findLecture(change : ChangedLecture) -> Lecture {
        var result : Lecture? = nil
        let changeHashValue = "\(change.name)\(change.oldRoom)\(change.oldDay)\(change.oldTime)".hashValue
        
        for lecture in Settings.sharedInstance.savedSchedule.selLectures {
            if(lecture.hashValue == changeHashValue){
                result = lecture
            }
        }
        return result!
    }
    
    // ID eines Events wird gesucht und zurückgegeben
    private func findEventId(lecture: Lecture, change: ChangedLecture) -> String{
        
        var result = ""
        for id in lecture.eventIDs {
            let event = self.eventStore.event(withIdentifier: id)
            //dump(event)
            if(event?.title == change.name && event?.startDate == combineDayAndTime(date: change.oldDate, time: change.oldTime)){
                result = id
            }
        }
        return result
    }
    
    
    // Aktualisiert Werte des übergebenem Events
    private func updateEvent(change : ChangedLecture) {
        let lecture = findLecture(change: change)
        
        let eventID = findEventId(lecture: lecture, change: change)
        
        let event = self.eventStore.event(withIdentifier: eventID)
        
        if((event) != nil) {
            if (change.newDay != "") {
                if (event?.startDate != combineDayAndTime(date: change.newDate!, time: change.newTime!)) {
                    let newEvent = EKEvent(eventStore: self.eventStore)
                    
                    newEvent.title     = "[NEU] " + change.name
                    newEvent.notes     = event?.notes
                    newEvent.startDate = combineDayAndTime(date: change.newDate!, time: change.newTime!)
                    newEvent.endDate   = (newEvent.startDate + 60 * 90)
                    
                    let str = lecture.room
                    let index = str.index(str.startIndex, offsetBy : 4)
                    let sub = str.substring(to: index)
                    
                    if(sub == "Mueb"){
                        newEvent.location = self.locationHuchschuleMuenchberg + " ," + lecture.room.appending(", \(change.newRoom)")
                        
                    } else {
                        newEvent.location = self.locationHochschuleHof + " ," + lecture.room.appending(", \(change.newRoom)")
                    }
                    
                    newEvent.calendar  = self.calendar!
                    newEvent.notes = lecture.comment + "  " + lecture.group
                    
                    createEvent(p_event: newEvent , lecture: lecture)
                    
                    event?.title    = "[Verschoben] " + change.name
                    event?.location = nil
                    event?.alarms   = []
                } else {
                    event?.title     = "[Raumänderung] " + change.name
                    
                    let str = lecture.room
                    let index = str.index(str.startIndex, offsetBy : 4)
                    let sub = str.substring(to: index)
                    
                    if(sub == "Mueb"){
                        event?.location = self.locationHuchschuleMuenchberg.appending(", \(change.newRoom)")
                        
                    } else {
                        event?.location = self.locationHochschuleHof.appending(", \(change.newRoom)")
                    }
                }
            } else {
                event?.title     = "[Entfällt] " + change.name
                event?.location = nil
                event?.alarms   = []
            }
            
            event?.calendar  = self.calendar!;
        }
        if((event) != nil) {
            do {
                try self.eventStore.save(event!, span: .thisEvent)
            } catch {
                print("Fehler beim Updaten eines Events")
            }
        }
    }
    
    // Entfernt mehrere übergebene Events
    func removeAllEvents(lectures : [Lecture]){
        if (checkCalendarAuthorizationStatus()) {
            for lecture in lectures {
                //let ids = lectureEKEventIdDictionary[lecture]
                //dump(lectureEKEventIdDictionary)
                
                let ids = lecture.eventIDs
                
                if (!ids.isEmpty) {
                    for id in ids {
                        _ = removeEvent(p_eventId: id, p_withNotes: true)
                    }
                }
            }
        }
    }
    
    //Entfernt übergebenes Event
    private func removeEvent(p_eventId: String, p_withNotes: Bool?=false)-> Bool{
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
}



