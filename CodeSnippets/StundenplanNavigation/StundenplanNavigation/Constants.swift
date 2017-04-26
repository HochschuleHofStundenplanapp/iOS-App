//
//  Constants.swift
//  StundenplanNavigation
//
//  Created by Peter Stöhr on 23.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import Foundation
import UIKit

class Constants :NSObject {
    static let weekDays = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"]
    
    static let HAWRed = UIColor(red: 194/255, green: 23/255, blue: 28/255, alpha: 1.0)
    static let HAWYellow = UIColor(red: 234/255, green: 184/255, blue: 26/255, alpha: 1.0)
    //static let HAWBlue = UIColor(red: 45/255, green: 68/255, blue: 144/255, alpha: 1.0)
    static let HAWBlue = UIColor(red: 0.0039, green: 0.4078, blue: 0.6824, alpha: 1.0)
    
    static let myEndDownload =  Notification.Name("endDownload")
    static let myNoInternet = Notification.Name("noInternet")
    
    // CalendarInterface
    static let locationHochschuleHof = "Campus Hof, Alfons-Goppel-Platz 1, 95028 Hof"
    static let locationHuchschuleMuenchberg = "Campus Münchberg, Kulmbacherstraße 76, 95213 Münchberg "
    static var calendarTitle : String = "Hochschule Hof Stundenplan App"
    static let locationInfoMueb = "Mueb"
    static let locationInfoHof = "Hof"
    static let changesNew = "[Neu] "
    static let changesChanged = "[Verschoben] "
    static let changesRoomChanged = "[Raumänderung] "
    static let changesFailed = "[Entfällt] "
    // Falls der AlarmOffset größer 0 ist wird ein Alarm gesetzt (Größeneinheit : Sekunden)
    static let calendarAlarmOffset = 0.0
}

enum Season : String {
    case Summer = "SS"
    case Winter = "WS"
    
    init?(term: String){
        if term == "SS"{
            self = .Summer
        }else if term == "WS"{
            self = .Winter
        }else{
            return nil
        }
    }
}

@objc enum Status : Int {
    case NoInternet = 0
    case DataLoaded = 1
    case Ready = 2
}
