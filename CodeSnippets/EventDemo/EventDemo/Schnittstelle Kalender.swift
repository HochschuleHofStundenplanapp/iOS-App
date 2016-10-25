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
    
    //var calendar : EKCalendar
    //
    let eventStore = EKEventStore()
    
    
    //Erzeugt Event und schreibt es in Kalender
    func create(event: Event) {
        let calEvent = EKEvent(eventStore: eventStore)
        
        calEvent.title = event.title
        calEvent.startDate = event.startDate
        calEvent.endDate = event.endDate
        calEvent.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(calEvent, span: .thisEvent)
        } catch {
            print("TODO Fehlermeldung \n KalenderAPI create")
        }
        
        event.eventID = calEvent.eventIdentifier
    }
    
    //Aktualisiert Werte des übergebenem Events
    func update(eventId: String, event: Event) {
        //TODO
    }

    //Entfernt übergebenes Event
    func delete(eventId: String)-> Bool{
        //TODO
        
        //Erfolgreich? Ja? Nein?
        return false
    }
    
    //Fügt vorhandenem Eintrag Alarm hinzu
    func setAlarm(eventId: String, alarm: [EKAlarm]){
        //TODO
        //let ekAlarm = EKAlarm(relativeOffset:-60)
        //event.addAlarm(ekAlarm)
    }
}
