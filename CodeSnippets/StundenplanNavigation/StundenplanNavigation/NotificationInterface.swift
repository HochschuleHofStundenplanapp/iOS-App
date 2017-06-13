//
//  NotificationInterface.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 13.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit
import UserNotifications


class NotificationInterface: NSObject {

    func makeNotification(changesAmount : Int, todayChangesAmount: Int){
        let content = UNMutableNotificationContent()
        
        var titleAmount = ""
        switch changesAmount {
        case 1:
            titleAmount = "eine"
        case 2:
            titleAmount = "zwei"
        case 3:
            titleAmount = "drei"
        default:
            titleAmount = "mehrere"
        }
        
        var title = ""
        
        if titleAmount == "eine"{
            title = "Es gibt \(titleAmount) neue Stundenplanänderung"
        } else {
            title = "Es gibt \(titleAmount) neue Stundenplanänderungen"
        }
        
        
        var descriptionAmount = ""
        switch todayChangesAmount {
        case 0:
            descriptionAmount = "keine"
        case 1:
            descriptionAmount = "eine"
        case 2:
            descriptionAmount = "zwei"
        case 3:
            descriptionAmount = "drei"
        default:
            descriptionAmount = "mehrere"
        }
        
        var description = ""
        
        if descriptionAmount == "eine"{
            description = "Davon \(descriptionAmount) heute"
        } else {
            description = "Davon \(descriptionAmount) heute"
        }
        
        
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: description, arguments: nil)
        
        var dateInfo = DateComponents()
        dateInfo.second  = 10
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        
        let request = UNNotificationRequest(identifier: "ChangesReminder", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
}
