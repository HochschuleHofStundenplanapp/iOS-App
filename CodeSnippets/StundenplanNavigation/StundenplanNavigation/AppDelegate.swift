//
//  AppDelegate.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit
import EventKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, myObserverProtocol {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Setup for Notifications and BackgroundFetch
        application.registerUserNotificationSettings ( UIUserNotificationSettings(types: [.alert, .badge,.sound],
                                                                                  categories: nil))
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        
        
    }
    
    // Background Fetch ###############################################################################
    
    var scheduleChangesController : ScheduleChangesController!
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        //Setup for downloading new Changes
//        scheduleChangesController = ScheduleChangesController()
//        scheduleChangesController.addNewObserver(o: self)
//        scheduleChangesController.handleAllChanges()
        
    }
    
    func update(s: String?) {
        print ( "Changes geladen")

        if ServerData.sharedInstance.lastAllChanges.count != ServerData.sharedInstance.allChanges.count && ServerData.sharedInstance.allChanges.count > 0{
        
            //New Changes are available
            let ResultChanges = compareChanges(oldChanges: ServerData.sharedInstance.lastAllChanges, newChanges: ServerData.sharedInstance.allChanges)
            
            let todayChanges = determineTodaysChanges(changedLectures: ResultChanges)
            
            if ResultChanges.count > 0 {
                self.makeNotification(changesAmount: ResultChanges.count, todayChangesAmount: todayChanges.count)
                
                //Hier könnte ein Badge gesetzt werden!
                
            } else{
                print("No Notification")
            }
            
            self.updateCalendar()
            
//            completionHandler(UIBackgroundFetchResult.newData)
        }
    }
    
    func updateCalendar(){
//        Settings.sharedInstance.savedChanges.sort()
//        if Settings.sharedInstance.savedCalSync {
//            if(CalendarInterface.sharedInstance.checkCalendarAuthorizationStatus()) {
//                CalendarInterface.sharedInstance.updateAllEvents(changes: Settings.sharedInstance.savedChanges)
//            }
//        }
    }
    
    
    //In Notification Klasse auslagern++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
    //In Notification Klasse auslagern++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    
    //In Changes Zugriffsschicht auslagern------------------------------------------------------------------------------
    func compareChanges(oldChanges: [ChangedLecture], newChanges: [ChangedLecture]) -> [ChangedLecture]{
        
        var resultChanges = [ChangedLecture]()
        
        for newChange in newChanges{
            var isNewChangedLecture = true
            for oldChange in oldChanges{
                if compareChangesDetails(chLecture: newChange, chLecture2: oldChange){
                    isNewChangedLecture = false
                }
            }
            if isNewChangedLecture{
                resultChanges.append(newChange)
            }
        }
        
        return resultChanges
        
    }
    private func compareChangesDetails(chLecture : ChangedLecture, chLecture2 : ChangedLecture) -> Bool {
        
        return (chLecture2.name == chLecture.name) && (chLecture2.oldRoom == chLecture.oldRoom) && (chLecture2.oldDay == chLecture.oldDay) && (chLecture2.newTime == chLecture.newTime) && (chLecture2.group == chLecture.group)
    }
    
    func determineTodaysChanges(changedLectures: [ChangedLecture]) -> [ChangedLecture]{
    
        let date = Date()
        var todayChanges = [ChangedLecture]()
    
        for change in changedLectures{
            let calendar = Calendar.current
            let currentMonth = calendar.component(.month, from: date)
            let currentDay = calendar.component(.day, from: date)
            
            let oldMonth = calendar.component(.month, from: change.oldDate)
            let oldDay = calendar.component(.day, from: change.oldDate)
            
            if currentMonth == oldMonth && currentDay == oldDay {
                todayChanges.append(change)
            }
        }
        
        return todayChanges
    }
    //In Changes Zugriffsschicht auslagern------------------------------------------------------------------------------
}

