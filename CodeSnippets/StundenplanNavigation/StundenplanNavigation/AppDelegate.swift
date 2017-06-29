//
//  AppDelegate.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit
import EventKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, myObserverProtocol {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Setup for Notifications and BackgroundFetch
        application.registerUserNotificationSettings ( UIUserNotificationSettings(types: [.alert, .badge,.sound],
                                                                                  categories: nil))
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        UserData.sharedInstance = DataObjectPersistency().loadDataObject()
        
        ServerData.sharedInstance.allChanges = UserData.sharedInstance.oldChanges
        
        print("Server: \(ServerData.sharedInstance.allChanges)")
        
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
    
    var handler: (UIBackgroundFetchResult) -> Void = {_ in}
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        handler = completionHandler
        
        //Setup for downloading new Changes
        scheduleChangesController = ScheduleChangesController()
        scheduleChangesController.addNewObserver(o: self)
        scheduleChangesController.handleAllChanges()
    }
    
    func update(s: String?) {
        print ( "Changes geladen")
        
        
        if ServerData.sharedInstance.lastAllChanges.count != ServerData.sharedInstance.allChanges.count && ServerData.sharedInstance.allChanges.count > 0{
        
            //New Changes are available
            let ResultChanges = ChangesController().compareChanges(oldChanges: ServerData.sharedInstance.lastAllChanges, newChanges: ServerData.sharedInstance.allChanges)
            
            let todayChanges = ChangesController().determineTodaysChanges(changedLectures: ResultChanges)
            
            if ResultChanges.count > 0 {
                NotificationInterface().makeNotification(changesAmount: ResultChanges.count, todayChangesAmount: todayChanges.count)
                
                //Hier könnte ein Badge gesetzt werden!
                UIApplication.shared.applicationIconBadgeNumber = ResultChanges.count
                
                
            } else{
                print("No Notification")
            }
            
            self.updateCalendar()
            
        }
    }
    
    func updateCalendar(){
        if UserData.sharedInstance.callenderSync {
            CalendarController().updateAllEvents(changes: AllChanges().getChangedLectures())
        }
    }
}
