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
    
    var ScheduleCalendarID : String = "Stundenplan"
    let eventStore = EKEventStore()
    // Für Zukunft: Alarm setzen
    // Wenn alarmOffset größer 0 wird Alarm gesetzt
    let alarmOffset = 0.0
    let locationHochschule = "Hochschule Hof, Alfons-Goppel-Platz 1, 95028 Hof"
    
    //Erzeugt Event und schreibt es in Kalender
    func create(p_event: EKEvent)-> String {
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                return self.internCreate(p_event: p_event)
            })
        } else {
            return self.internCreate(p_event: p_event)
        }
        return ""
    }
    
    private func internCreate(p_event: EKEvent)-> String {
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
        
        event.calendar  = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
        } catch {
            print("TODO Fehlermeldung \n KalenderAPI create")
        }
        
        //p_event.eventIdentifier = event.eventIdentifier
        
        return event.eventIdentifier
    }
    
    //Aktualisiert Werte des übergebenem Events
    func update(p_eventId: String, p_event: EKEvent, p_wasDeleted: Bool) {
        // andere Überprüfung ob Zugriff gewährt
        /*[eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
         if (!granted)
         {
         dispatch_async(dispatch_get_main_queue(), ^{
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot access Calendar" message:@"Please give the permission to add task in calendar from iOS > Settings > Privacy > Calendars" delegate:nil  cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [alert show];
         
         });
         return;
         }
         
         if (error)
         {
         NSLog(@"%@", error);
         }
         
         //}];
         */
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                self.internUpdate(p_eventId: p_eventId, p_event: p_event, p_wasDeleted: p_wasDeleted)
            })
        } else {
            self.internUpdate(p_eventId: p_eventId, p_event: p_event, p_wasDeleted: p_wasDeleted)
        }
    }
    
    private func internUpdate(p_eventId: String, p_event: EKEvent, p_wasDeleted: Bool) {
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
                    
                    internCreate(p_event: newEvent)
                    
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
            
            event?.calendar  = eventStore.defaultCalendarForNewEvents;
            
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

    //Entfernt übergebenes Event
    func delete(p_eventId: String, p_withNotes: Bool?=false)-> Bool{
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                return self.internDelete(p_eventId: p_eventId, p_withNotes: p_withNotes)
            })
        } else {
            return self.internDelete(p_eventId: p_eventId, p_withNotes: p_withNotes)
        }
        
        return false
    }
    
    private func internDelete(p_eventId: String, p_withNotes: Bool?=false)-> Bool{
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
}
