//
//  CalendarInterface.swift
//  StundenplanNavigation
//
//  Created by Daniel on 13.12.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit
import EventKit
import StundenplanFramework

class CalendarInterface: NSObject {
    
    static var sharedInstance = CalendarInterface()
    
    var calendar: EKCalendar?
    var eventStore: EKEventStore
    var calendarData: CalendarData
    
    private override init() {
        eventStore = EKEventStore()
        calendarData = DataObjectPersistency().loadCalendarData()
        
        super.init()
        
        if(!isAuthorized()){
            requestAccessToCalendar()
        } else {
            createCalenderIfNeeded()
        }
    }
    
    // MARK: - Kalendar-Methoden
    
    /**
     Erstellen eines Kalenders
     */
    private func createCalender(){
        let newCalendar = EKCalendar(for: .event, eventStore: self.eventStore)
        
        newCalendar.title = Constants.calendarTitle
        
        //NEU: in iCloud und alternativ local
        let sourcesInEventStore = eventStore.sources
        
        // Filter the available sources and select the "icloud" source to assign to the new calendar's
        // source property
        //print("create icloud calendar")
        newCalendar.source = sourcesInEventStore.filter{
            (source: EKSource) -> Bool in
            (source.sourceType.rawValue == EKSourceType.calDAV.rawValue)
            &&
            (source.title == "iCloud")
            }.first
            
        if newCalendar.source == nil {
            //print("create lokal calendar")
            newCalendar.source = sourcesInEventStore.filter{
                (source: EKSource) -> Bool in
                source.sourceType.rawValue == EKSourceType.local.rawValue
                }.first!
        }
        
        // Save the calendar using the Event Store instance
        do {
            try eventStore.saveCalendar(newCalendar, commit: true)
            
            self.calendar = newCalendar
            UserData.sharedInstance.calendarIdentifier = calendar?.calendarIdentifier
        } catch {
            print(error)
            print("Fehler bei create Calendar")
        }
        
        //ALT
//        newCalendar.source = eventStore.defaultCalendarForNewEvents?.source
//        do {
//            try self.eventStore.saveCalendar(newCalendar, commit: true)
//            self.calendar = newCalendar
//
//            UserData.sharedInstance.calendarIdentifier = calendar?.calendarIdentifier
//        } catch {
//            print(error)
//            print("Fehler bei create Calendar")
//        }
    }
    
    /**
     Erstellt einen neuen Kalender, falls noch keiner vorhanden ist.
     
     
     */
    public func createCalenderIfNeeded() {
        removeOldCalenderFromIOSCalendar()
        
        if (!isAppCalenderAvailable()) {
            createCalender()
        }
    }
    
    /**
     Check ob App-Calender schon vorhanden ist
     */
    private func isAppCalenderAvailable() -> Bool {
        if calendar != nil {
            return true
        } else if let existingCalendar = getExistingCalendar() {
            self.calendar = existingCalendar
            return true
        } else {
            return false
        }
    }
    
    /**
     Läd, falls vorhanden den bereits existierenen Kalender aus dem `EKEventStore`.
     */
    private func getExistingCalendar() -> EKCalendar? {
        let calendars = self.eventStore.calendars(for: .event)
        let savedCalendarIdentifier = UserData.sharedInstance.calendarIdentifier
        for calendar in calendars {
            if calendar.calendarIdentifier == savedCalendarIdentifier {
                return calendar
            }
        }
        return nil
    }
    
    /**
     Löschen eines Kalenders
     */
    func removeCalendar() {
        if isAppCalenderAvailable() {
            do {
                try self.eventStore.removeCalendar(self.calendar!, commit: true)
                calendarData.changesEventIdDictonary.removeAll()
                calendarData.lecturesEventIdDictonary.removeAll()
                UserData.sharedInstance.calendarIdentifier = nil
                self.calendar = nil
            } catch {
                print("CalendarInterface-removeCalendar-error")
                print(error)
            }
        }
    }
    
    
    /**
     Ergänzt calendar identifier in UserData für bereits gespeicherten Kalender
     Löscht alten Kalender, falls doppelt vorhanden oder identifier nicht passt
     Damit nicht zwei Kalender nach dem nächsten AppStore-Update im iOS Kalender auftauchen.
     */
    private func removeOldCalenderFromIOSCalendar() {
        if isAuthorized() {
            var identifierStoredInUserData = false
            var storedIdentifier = ""
            
            //identifier bereits gespeichert
            if UserData.sharedInstance.calendarIdentifier != nil {
                identifierStoredInUserData = true
                storedIdentifier = UserData.sharedInstance.calendarIdentifier!
            }
            
            //identifier mus gespeichert werden
            if !identifierStoredInUserData {
                let allCalendars = eventStore.calendars(for: .event)
                for calendar in allCalendars {
                    //neuer Identifier  nach Update noch nicht gespeichert -> dann speichern
                    if calendar.title == Constants.calendarTitle && !identifierStoredInUserData {
                        //identifier erstmals nach Update in UserData speichern
                        UserData.sharedInstance.calendarIdentifier = calendar.calendarIdentifier
                        identifierStoredInUserData = true
                    }
                    
                    //falls mehrere HS Kalender vorhanden sind, aber Identifier nicht passt
                    //nur zur Sicherheit, braucht es eigentlich nicht, sofern alles richtig funktioniert
                    if calendar.title == Constants.calendarTitle && identifierStoredInUserData && calendar.calendarIdentifier != storedIdentifier {
                        do {
                            try eventStore.removeCalendar(calendar, commit: true)
                        } catch {
                            print(error)
                        }
                        
                    }
                }
            }
        }
    }
    
    
    
    // MARK: - Berechtigungs-Methoden
    
    /**
     Berechtigungen für den Kalenderzugriff anfragen
     */
    private func requestAccessToCalendar (){
        if !isAuthorized() {
            self.eventStore.requestAccess(to: .event, completion: { granted, error in
                DispatchQueue.main.async {
                    if granted {
                        UserData.sharedInstance.calenderSync = true
                        NotificationCenter.default.post(name: .calendarSyncChanged , object: nil)
                        self.createCalenderIfNeeded()
                    } else {
                        UserData.sharedInstance.calenderSync = false
                        NotificationCenter.default.post(name: .calendarSyncChanged , object: nil)
                    }
                }
            })
        }
    }
    
    public func isAuthorized() -> Bool {
        return EKEventStore.authorizationStatus(for: EKEntityType.event) == EKAuthorizationStatus.authorized
    }
    
    // MARK: - Eintrag-Methoden
    
    /**
     Schreibt übergebene Events in den Kalender
     */
    func createEvent(p_event : EKEvent, key : String, isChanges : Bool){
        if UserData.sharedInstance.calenderSync {
            
            
            let event       = EKEvent(eventStore: eventStore)
            event.title     = p_event.title
            event.notes     = p_event.notes
            event.startDate = p_event.startDate
            event.endDate   = p_event.endDate
            event.location  = p_event.location
            
            if Constants.calendarAlarmOffset > 0 {
                var ekAlarms = [EKAlarm]()
                ekAlarms.append(EKAlarm(relativeOffset:-Constants.calendarAlarmOffset))
                event.alarms    = ekAlarms
            }
            
            event.calendar  = calendar!
            
            //print("\t\t---> \(event.title) - \(event.startDate) - \(event.endDate)")
            
            do {
                try eventStore.save(event, span: .thisEvent, commit: true)
            } catch {
                print("Fehler beim erzeugen eines Events und beim Eintragen des Events")
            }
            
            if isChanges {
                addChangesID(eventID: event.eventIdentifier, key: key)
            } else {
                addLecturesID(eventID: event.eventIdentifier, key: key)
            }
        }
    }
    
    func updateEvent(eventID : String, updatedEvent : EKEvent, key : String, lectureToChange : Bool) {
        let event = getEventWithEventID(eventID: eventID)
        if(event != nil){
            if (event?.title != "") {
                event?.title     = updatedEvent.title
                event?.notes     = updatedEvent.notes
                event?.startDate = updatedEvent.startDate
                event?.endDate   = updatedEvent.endDate
                event?.location  = updatedEvent.location
                event?.calendar  = self.calendar!
                event?.timeZone = NSTimeZone.local
                
                do {
                    try self.eventStore.save(event!, span: .thisEvent)
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
    }
    
    /**
     Entfernt übergebenes Event
     */
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
    
    public func getEventWithEventID(eventID : String) -> EKEvent!{
        // TODO: Fehlermeldungen abfangen
        if (eventID != "") {
            let event = self.eventStore.event(withIdentifier: eventID)
            if (event != nil) {
                return event!
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    /**
     ID eines Events im Kalender wird gesucht und zurückgegeben
     */
    public func findEventId(key : String, title : String, startDate : Date, onlyChanges : Bool) -> String{
        var result = ""
        if (!onlyChanges) {
            if let lectureIDs = calendarData.lecturesEventIdDictonary[key] {
                for id in lectureIDs {
                    let event = CalendarInterface.sharedInstance.getEventWithEventID(eventID: id)
                    if(event != nil){
                        if (event?.startDate == startDate) { // TODO Test  event.title == title &&
                            result = id
                        }
                    }
                }
            }
        }
        if let changesIDs = calendarData.changesEventIdDictonary[key] {
            for id in changesIDs {
                let event = CalendarInterface.sharedInstance.getEventWithEventID(eventID: id)
                if (event?.startDate == startDate) { // TODO Test  event.title == title &&
                    result = id
                }
            }
        }
        return result
    }
    
    public func doEventExist(key: String, startDate: Date) -> Bool {
        if let lectureIDs = calendarData.lecturesEventIdDictonary[key] {
            for id in lectureIDs {
                let event = CalendarInterface.sharedInstance.getEventWithEventID(eventID: id)
                if(event != nil){
                    if (event?.startDate == startDate) { // TODO Test  event.title == title &&
                        return true
                    }
                }
            }
        }
        if let lectureIDs = calendarData.changesEventIdDictonary[key] {
            for id in lectureIDs {
                let event = CalendarInterface.sharedInstance.getEventWithEventID(eventID: id)
                if(event != nil){
                    if (event?.startDate == startDate) { // TODO Test  event.title == title &&
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func addLecturesID(eventID : String, key : String) {
        // Event ID zu Dictonary hinzufügen
        if var lectureIDs = calendarData.lecturesEventIdDictonary[key] {
            lectureIDs.append(eventID)
            calendarData.lecturesEventIdDictonary[key] = lectureIDs
        } else {
            calendarData.lecturesEventIdDictonary[key] = [eventID]
        }
    }
    
    func addChangesID(eventID : String, key : String) {
        // Event ID zu Dictonary hinzufügen
        if var lectureIDs = calendarData.changesEventIdDictonary[key] {
            lectureIDs.append(eventID)
            calendarData.changesEventIdDictonary[key] = lectureIDs
        } else {
            calendarData.changesEventIdDictonary[key] = [eventID]
        }
    }
    
    func removeLecturesID(eventID : String, key : String) {
        // Event ID zu Dictonary hinzufügen
        if var lectureIDs = calendarData.lecturesEventIdDictonary[key] {
            let eventIDIndex = lectureIDs.index(of: eventID)
            lectureIDs.remove(at: eventIDIndex!)
            calendarData.lecturesEventIdDictonary[key] = lectureIDs
        }
    }
    
    func removeChangesID(eventID : String, key : String) {
        // Event ID zu Dictonary hinzufügen
        if var lectureIDs = calendarData.changesEventIdDictonary[key] {
            let eventIDIndex = lectureIDs.index(of: eventID)
            lectureIDs.remove(at: eventIDIndex!)
            calendarData.changesEventIdDictonary[key] = lectureIDs
        }
    }
    
    public func getIDFromDictonary(key: String) -> [String] {
        var IDs = [String]()
        if let lectureIDs = calendarData.lecturesEventIdDictonary[key] {
            for lecturesID in lectureIDs {
                IDs.append(lecturesID)
            }
        }
        if let changesIDs = calendarData.changesEventIdDictonary[key] {
            for changesID in changesIDs {
                IDs.append(changesID)
            }
        }
        return IDs
    }
    
    public func removeIdsFromDictonary(key: String) {
        if (calendarData.lecturesEventIdDictonary[key] != nil) {
            calendarData.lecturesEventIdDictonary[key] = []
        }
        if calendarData.changesEventIdDictonary[key] != nil {
            calendarData.changesEventIdDictonary[key] = []
        }
    }
    
    public func saveIDs() {
        DataObjectPersistency().saveCalendarData(items: calendarData)
    }
    
    public func addTaskToCalendar(task: Task) {
        var foundLectureToTask = false
//        print("addTask: \(task)")

        if let events = getCalendarEvents() {
            for event in events {
                //Termin für Lecture an diesem Tag
                if event.title == task.lecture && event.startDate.formattedDate == task.dueDate.formattedDate {
                    foundLectureToTask = true
                    let taskNote = "offene Aufgabe: \(task.title)\n\(task.taskDescription)"
                    if event.notes == nil {
                        event.notes = taskNote
                    } else {
                        event.notes?.append("\n\(taskNote)")
                    }
                    event.title.insert(contentsOf: Constants.hasTaskNote, at: event.title.startIndex)
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    } catch {
                        print("CalendarInterface-Error: addTaskToCalendar")
                    }
                }
            }
        }
        
        //Termin ohne Lecture an diesem Tag
        if !foundLectureToTask {
            if UserData.sharedInstance.calenderSync {
                let event = EKEvent(eventStore: eventStore)
                
                event.title     = "\(Constants.hasTaskNote) Offene Aufgabe: \(task.title)"
                if(task.lecture != "") {
                    event.title.append(" [\(task.lecture)]")
                }
                event.notes     = "\(task.title)\n\(task.taskDescription)"
                event.startDate = task.dueDate
                event.endDate = task.dueDate
                event.isAllDay  = true
                event.location  = "HS Hof"
                
                if Constants.calendarAlarmOffset > 0 {
                    var ekAlarms = [EKAlarm]()
                    ekAlarms.append(EKAlarm(relativeOffset:-Constants.calendarAlarmOffset))
                    event.alarms    = ekAlarms
                }
                
                event.calendar  = calendar!
                
                do {
                    try eventStore.save(event, span: .thisEvent, commit: true)
                } catch {
                    print("CalendarInterface-Error: addTaskToCalendar2")
                }
            }
        }
    }
    
    public func removeTaskFromCalendar(task: Task) {
//        print("task: \(task.title) \(task.dueDate) \(task.taskDescription)")
        if let events = getCalendarEvents() {
            for event in events {
//                print("remove event: \(event)")
                if event.title == "\(Constants.hasTaskNote)\(task.lecture)" && event.startDate.formattedDate == task.dueDate.formattedDate {
                    let taskNote = "offene Aufgabe: \(task.title)\n\(task.taskDescription)"
                    event.notes = event.notes?.replacingOccurrences(of: taskNote, with: "")
                    event.title = event.title.replacingOccurrences(of: Constants.hasTaskNote, with: "")
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    } catch {
                        print("CalendarInterface-Error: removeTaskFromCalendar")
                    }
                } else if event.title.starts(with: "\(Constants.hasTaskNote) Offene Aufgabe: \(task.title)") && event.startDate.formattedDate == task.dueDate.formattedDate {
                    do {
                        try eventStore.remove(event, span: .thisEvent)
                    } catch {
                        print("CalendarInterface-Error: removeTaskFromCalendar")
                    }
                }
            }
        }
    }
    
    private func getCalendarEvents() -> [EKEvent]? {
        if let calendar = calendar {
            let prediction = eventStore.predicateForEvents(withStart: Date(), end: Date.distantFuture, calendars: [calendar])
            let events = eventStore.events(matching: prediction)
            return events
        }
        return nil
    }
    
}



