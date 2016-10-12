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
    
    
    //Erzeugt Event und schreibt es in Kalender
    func create(title: String, startDate: Date, endDate: Date, location: String, description: String) -> String{
        
        //liefert EventId zurück
        return ""
    }
    
    //Aktualisiert Werte des übergebenem Events
    func update(eventId: String, title: String, startDate: Date, endDate: Date, location: String, description: String) -> String{
        
        //liefert EventId zurück
        return ""
    }

    //Entfernt übergebenes Event
    func delete(eventId: String)-> Bool{
        
        //Erfolgreich? Ja? Nein?
        return false
    }
    
    //Fügt vorhandenem Eintrag Alarm hinzu
    func setAlarm(eventId: String, alarm: [EKAlarm]){
        
    }
}
