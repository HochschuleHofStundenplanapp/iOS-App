//
//  AppointmentController.swift
//  StundenplanFramework
//
//  Created by Bastian Kusserow on 09.01.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import Foundation
import StundenplanFramework

public class AppointmentController {
    
    public static func isLectureFreeDay() -> Bool {
        var freeDays = DataObjectPersistency().loadDataObject().appointments[1].appointments
        
        freeDays.append(Appointment(name: "Test Termin", date: DateInterval(start: Date(), end: Date())))
        
        let freeDay = freeDays.contains { (appointment) -> Bool in
            //print(appointment.date.start.description(with: Locale.init(identifier: "de")))
            let range = (appointment.date.start.timeIntervalSince1970...Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: appointment.date.end)!.timeIntervalSince1970)
            
            return range.contains(Date().timeIntervalSince1970)
        }
        
        return freeDay
    }
    
    public static func getFreeDayAppointment() -> Appointment? {
        let freeDays = DataObjectPersistency().loadDataObject().appointments[1].appointments
        let appointment = freeDays.first { (appointment) -> Bool in
            let range = (appointment.date.start.timeIntervalSince1970...Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: appointment.date.end)!.timeIntervalSince1970)
            
            return range.contains(Date().timeIntervalSince1970)
        }
        
        return appointment
    }
}

