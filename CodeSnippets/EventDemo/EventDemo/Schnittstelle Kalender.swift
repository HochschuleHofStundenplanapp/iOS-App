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
        event.location  = p_event.location
        event.alarms    = p_event.alarms
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
    func update(p_eventId: String, p_event: EKEvent) {
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
                self.internUpdate(p_eventId: p_eventId, p_event: p_event)
            })
        } else {
            self.internUpdate(p_eventId: p_eventId, p_event: p_event)
        }
    }
    
    private func internUpdate(p_eventId: String, p_event: EKEvent) {
        let event = eventStore.event(withIdentifier: p_eventId)
        
        if((event) != nil) {
            event?.title     = p_event.title
            // TODO Notes auch oder nicht?
            event?.notes     = p_event.notes
            event?.startDate = p_event.startDate
            event?.endDate   = p_event.endDate
            event?.location  = p_event.location
            event?.alarms    = p_event.alarms
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
    func delete(p_eventId: String)-> Bool{
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                return self.internDelete(p_eventId: p_eventId)
            })
        } else {
            return self.internDelete(p_eventId: p_eventId)
        }
        
        return false
    }
    
    private func internDelete(p_eventId: String)-> Bool{
        let eventToRemove = eventStore.event(withIdentifier: p_eventId)
        if (eventToRemove != nil) {
            do {
                try eventStore.remove(eventToRemove!, span: .thisEvent)
                return true
            } catch {
                print("Bad things happened")
            }
        }
        return false
    }
    
    /*
    //Fügt vorhandenem Eintrag Alarm hinzu
    func setAlarm(p_eventId: String, p_alarm: [EKAlarm]){
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                self.internSetAlarm(p_eventId: p_eventId, p_alarm: p_alarm)
            })
        } else {
            self.internSetAlarm(p_eventId: p_eventId, p_alarm: p_alarm)
        }
    }
    
    private func internSetAlarm(p_eventId: String, p_alarm: [EKAlarm]) {
        let event = eventStore.event(withIdentifier: p_eventId)
        
        if((event) != nil) {
            event?.alarms = p_alarm
            //event?.addAlarm(p_alarm)
            
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
    */
}
