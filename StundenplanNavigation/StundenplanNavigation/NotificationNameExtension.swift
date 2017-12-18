//
//  NotificationNameExtension.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 15.05.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let coursesDownloadEnded =  Notification.Name("courseDownloadEnded")
    static let lecturesDownloadEnded = Notification.Name("LecturesDownloadEnded")
    static let coursesDownloadFailed =  Notification.Name("coursesDownloadFailed")
    static let lecturesDownloadFailed = Notification.Name("lecturesDownloadFailed")
    static let calendarSyncChanged =   Notification.Name("calendarSyncChanged")
    static let showHasNoAccessAlert = Notification.Name("showHasNoAccessAlert")
    static let completedTaskChanged = NSNotification.Name("completedTaskChanged")
    static let appColorHasChanged = NSNotification.Name("appColorHasChanged")
    static let finishedOnboarding = NSNotification.Name("finishedOnboarding")
}
