//
//  Constants.swift
//  StundenplanNavigation
//
//  Created by Peter Stöhr on 23.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import Foundation
import UIKit

public class Constants :NSObject {
    public static let weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag","Sonntag"]
    
    public static let username = "soapuser"
    public static let password = "F%98z&12"
    public static let baseURI = "https://app.hof-university.de/soap/"
        
    // CalendarInterface
    public static let locationHochschuleHof = "Campus Hof, Alfons-Goppel-Platz 1, 95028 Hof"
    public static let locationHuchschuleMuenchberg = "Campus Münchberg, Kulmbacherstraße 76, 95213 Münchberg "
    public static var calendarTitle = "Hochschule Hof Stundenplan App"
    public static let locationInfoMueb = "Mueb"
    public static let locationInfoHof = "Hof"
    public static let changesNew = "[Neu] "
    public static let changesChanged = "[Verschoben] "
    public static let changesRoomChanged = "[Raumänderung] "
    public static let changesFailed = "[Entfällt] "
    public static let readNotes = "[Notizen lesen] "
    public static let noteNotParsable = "Terminangaben unklar, bitte selber überprüfen: "
    // Falls der AlarmOffset größer 0 ist wird ein Alarm gesetzt (Größeneinheit : Sekunden)
    public static let calendarAlarmOffset = 0.0
    
    public static let changesButtonTitle = "Änderungen übernehmen"
    public static let appGroupID = "group.iosapps.hof-university.stundenplan"
}

@objc public enum Status : Int {
    case NoInternet = 0
    case DataLoaded = 1
    case Ready = 2
}
