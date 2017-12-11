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
class AppDelegate: UIResponder, UIApplicationDelegate, myObserverProtocol,UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Setup for Notifications and BackgroundFetch
            
            
            //UIUserNotificationSettings(types: [.alert, .badge,.sound],categories: nil)
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
            UserData.sharedInstance = DataObjectPersistency().loadDataObject()
            UNUserNotificationCenter.current().delegate = self
//        ServerData.sharedInstance.allChanges = UserData.sharedInstance.oldChanges
        
//        print("Server: \(ServerData.sharedInstance.allChanges)")
        
        
        UIApplication.shared.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DeviceToken1: \(deviceToken)")
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("DeviceToken: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
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
    
    var tempOldChanges : [ChangedLecture] = []
    
    
    var handler: (UIBackgroundFetchResult) -> Void = {_ in}
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        handler = completionHandler
        
        //Setup for downloading new Changes
        scheduleChangesController = ScheduleChangesController()
        scheduleChangesController.addNewObserver(o: self)
        tempOldChanges = UserData.sharedInstance.oldChanges
        scheduleChangesController.handleAllChanges()
    }
    
    func update(s: String?) {
        print ( "Changes geladen")
        
        
        if UserData.sharedInstance.oldChanges.count != tempOldChanges.count && UserData.sharedInstance.oldChanges.count > 0{
        
            //New Changes are available
            let ResultChanges = ChangesController().compareChanges(oldChanges: tempOldChanges, newChanges: UserData.sharedInstance.oldChanges)
            
            let todayChanges = ChangesController().determineTodaysChanges(changedLectures: ResultChanges)
            
            if ResultChanges.count > 0 {
                print("Scho Notification")

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
        if UserData.sharedInstance.calenderSync {
            CalendarController().updateAllEvents(changes: AllChanges().getChangedLectures())
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("recive Notification do something with it")
        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        switch application.applicationState{
            case .active:
                removeAllNotifications()
                //Get called when the app is open/active
                switchToChanges()
            case .inactive:
                //Get called when the user press on a remote notification
                removeAllNotifications()
                switchToChanges()
            
            case .background:
                print("background")
            }
       }
    
    func switchToChanges(){
        if self.window!.rootViewController as? UITabBarController != nil {
            let tabbarController = self.window!.rootViewController as! UITabBarController
            tabbarController.selectedIndex = 1
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {

        completionHandler([.alert, .badge, .sound])
    }
    func removeAllNotifications(){
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    
//    func registerForPushNotification(){
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
//            (granted, error) in
//            print("Permission granted: \(granted)")
//        }
//    }
}
