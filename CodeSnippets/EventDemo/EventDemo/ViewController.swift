//
//  ViewController.swift
//  EventDemo
//
//  Created by Jonas Beetz on 11.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    
    var savedEventId : String = ""
    let schnittstelle = Schnittstelle_Kalender()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Creates an event in the EKEventStore. The method assumes the eventStore is created and
    // accessible
    func createEvent(_ eventStore: EKEventStore, title: String, startDate: Date, endDate: Date) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        let ekAlarm = EKAlarm(relativeOffset:-60)
        event.addAlarm(ekAlarm)
        //   event.alarms = [ekAlarm]
        
        do {
            try eventStore.save(event, span: .thisEvent)
            savedEventId = event.eventIdentifier
            print("Identifier " + event.eventIdentifier)
            
        } catch {
            print("Bad things happened")
        }
    }
    
    // Removes an event from the EKEventStore. The method assumes the eventStore is created and
    // accessible
    func deleteEvent(_ eventStore: EKEventStore, eventIdentifier: String) {
        let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
        if (eventToRemove != nil) {
            do {
                try eventStore.remove(eventToRemove!, span: .thisEvent)
            } catch {
                print("Bad things happened")
            }
        }
    }
    
    // Responds to button to add event. This checks that we have permission first, before adding the
    // event
    @IBAction func addEvent(_ sender: UIButton) {
        var startDate = Date().addingTimeInterval(120)
        var endDate = startDate.addingTimeInterval(60 * 60) // One hour
        
        //createEvent(eventStore, title: "Test Event", startDate: startDate, endDate: endDate)
        print("start\n")
        
        /*let eventStore = schnittstelle.eventStore
        
        let event = EKEvent(eventStore: eventStore)
        
        event.title     = "Vorlesung"
        event.startDate = startDate
        event.endDate   = endDate
        event.location  = "FB004b"
        event.calendar  = eventStore.defaultCalendarForNewEvents
        
        var ekAlarms = [EKAlarm]()
        ekAlarms.append(EKAlarm(relativeOffset:-60))
        event.alarms = ekAlarms
        */
        
        var lectrues = [Lecture]()
        
        let lectrue = Lecture(id: 12345, name: "Testvorlesung", lecturer: "Herr Dozent", type: "Vorlesung", group: "Gruppe", starttime: Date(), endTime: Date(), startdate: Date(), enddate: Date(), day: "Montag", room: "FA001", course: "MC", comment: "Ab WK 40", selected: true)
        
        lectrues.append(lectrue)
        
        schnittstelle.createAllEvents(lectures: lectrues)
        
        //TODO Events speichern
        
        //print("EventIdentifier " + self.savedEventId)
        
        print("create end\n")
        
        
        //startDate = Date().addingTimeInterval(3720)
        //endDate = startDate.addingTimeInterval(60 * 60) // One hour
        /*
        let editEvent = EKEvent(eventStore: eventStore)
        
        editEvent.title     = "Vorlesung"
        editEvent.startDate = startDate
        editEvent.endDate   = endDate
        editEvent.location  = "FA104"
        editEvent.calendar  = eventStore.defaultCalendarForNewEvents
        
        print ("update event and add alarm")
        */
        //schnittstelle.update(p_eventId: savedEventId, p_event: editEvent, p_wasDeleted: false)
        
        
        //print ("deleted:")
        //print (schnittstelle.delete(p_eventId: savedEventId))
        
    }
    
    
    // Responds to button to remove event. This checks that we have permission first, before removing the
    // event
    @IBAction func removeEvent(_ sender: UIButton) {
        //let schnittstelle = Schnittstelle_Kalender()
        
        //print (schnittstelle.delete(p_eventId: savedEventId))
        
        let eventStore = schnittstelle.eventStore
        
        eventStore.defaultCalendarForNewEvents.rollback()
    }
}

