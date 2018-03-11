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
import StundenplanFramework


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, myObserverProtocol,UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserData.sharedInstance = DataObjectPersistency().loadDataObject()
        
        let faculty = Faculty(facultyName: UserData.sharedInstance.getSelectedAppColor())
        appColor.faculty = faculty
        
        let navbar = UINavigationBar.appearance()
        setupAppColor()
        navbar.barTintColor = appColor.tintColor
        
        //Setup for Notifications and BackgroundFetch
            
            
            //UIUserNotificationSettings(types: [.alert, .badge,.sound],categories: nil)
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        UNUserNotificationCenter.current().delegate = self
//      ServerData.sharedInstance.allChanges = UserData.sharedInstance.oldChanges
        checkForSemesterAppointments()
//      print("Server: \(ServerData.sharedInstance.allChanges)")
        
        //beim App Start für Notifications und Push registrieren
        registerForPushNotification()
        
        return true
    }
    
    func checkForSemesterAppointments() {
//        print(UserData.sharedInstance.appointments.count)
//        print("checkSemester: \(Date().checkSemester()) und in UserData: \(UserData.sharedInstance.currentSemester)")
        if UserData.sharedInstance.appointments.count == 0 || Date().checkSemester() != UserData.sharedInstance.currentSemester {
//            print("Noch keine Termine vorhanden..Termine werden geparsed und gespeichert")
            let parser = AppointmentParser()
            parser.downloadAndParseAppointmentContent()
        }
    }
    
    func setupAppColor(){
        switch UserData.sharedInstance.getSelectedAppColor() {
        case Faculty.economics.faculty:
            appColor.faculty = Faculty.economics
        case Faculty.computerScience.faculty:
            appColor.faculty = Faculty.computerScience
        case Faculty.engineeringSciences.faculty:
            appColor.faculty = Faculty.engineeringSciences
        default:
            //print("selected appcolor was: " + UserData.sharedInstance.getSelectedAppColor())
            appColor.faculty = Faculty.default
        }
        
        //print("loaded Color", appColor.faculty)
        
        let barButton = UIBarButtonItem.appearance()
        barButton.tintColor = UIColor.white
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        //print("DeviceToken: \(token)")
        forwardTokenToServer(deviceToken: token)
    }
    
    func forwardTokenToServer(deviceToken: String){
        //now find all courses
        let lectures = UserData.sharedInstance.selectedSchedule.getOneDimensionalList()
        //print("lectures->count\(lectures.count)")
        var jsonLectures : [String: [Any]] = [:]
        var tmpArray: [String] = []
        for item in lectures{
            if !tmpArray.contains(item.splusname){ //hotfix should be fix on my_schedule 
                tmpArray.append(item.splusname)
            }
        }
        jsonLectures.updateValue(tmpArray, forKey: "lecture")
        var payload : [String: Any] = ["fcm_token": deviceToken]
        payload.updateValue(tmpArray, forKey: "vorlesung_id")
        
        let osParam = 1
        payload.updateValue(osParam, forKey: "os")
        
        
        
        // can be disabled. server doesn't expect it.
//        if (true) {
//            let lang : String = "de"
//            payload.updateValue(lang, forKey: "language")
//        }
        
        
        let isValidJson = JSONSerialization.isValidJSONObject(payload)
        if isValidJson{
            sendToServer(jsonObject: payload)
            print("register push by server")
        }else{
            print("JSON not valid")
        }
    }
    func sendToServer(jsonObject: [String: Any]){
        //### Authentication soap
        let username = "soapuser"
        let password = "F%98z&12"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        var myUrl : String?
        
        //get data from info.plist
        let resourceFileDictinoary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"){
            resourceFileDictinoary = NSDictionary(contentsOfFile: path)
            if let dict = resourceFileDictinoary{
                if !(dict["isPushTesting"] as! Bool){
                   let productive = dict["ProductiveURL"] as! String
//                    myUrl = productive + "fcm_update_and_send.php?os=1" // 0 = Android, 1 = iOS
                    myUrl = productive + "fcm_register_user.php?os=1" // 0 = Android, 1 = iOS
                }
                else{
                    myUrl = dict["TestURL"] as! String + "fcm_register_user.php?os=1"
                }
                //### if isPushTesting plist change url
                var request = URLRequest(url:URL(string: myUrl!)!)
                request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
                request.httpMethod = "POST"
                let params = jsonObject
                request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
//                print("URL: \(myUrl)")
//                print(params)
                
                //http request
                URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
                    if let _ = data{
                        //print("response: \(String(describing: String(data:safeData, encoding:.utf8)))")
                    }
                    }.resume()

            }
            else{
                    print("oops! Something went wrong")
        }
        
        }
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
        
        //### deprecated because of remote notifictation
        if UserData.sharedInstance.oldChanges.count != tempOldChanges.count && UserData.sharedInstance.oldChanges.count > 0{
//            //New Changes are available
//            let ResultChanges = ChangesController().compareChanges(oldChanges: tempOldChanges, newChanges: UserData.sharedInstance.oldChanges)
//
//            let todayChanges = ChangesController().determineTodaysChanges(changedLectures: ResultChanges)
//
//            if ResultChanges.count > 0 {
//                print("Show Notification")
//
//                NotificationInterface().makeNotification(changesAmount: ResultChanges.count, todayChangesAmount: todayChanges.count)
//
//                //Hier könnte ein Badge gesetzt werden!
//                UIApplication.shared.applicationIconBadgeNumber = ResultChanges.count
//
//
//            } else{
//                print("No Notification")
//            }
        
            self.updateCalendar()
            
        }
    }
    
    func updateCalendar(){
        if UserData.sharedInstance.calenderSync {
            CalendarController().updateAllEvents(changes: AllChanges().getChangedLectures())
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //print("recive Notification do something with it")
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
    func registerForPushNotification() {
        
        //notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
           
            guard granted else {
                return
            }
            self.getNotificationSettings()
        }
    }
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
//            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
//            print("register for remote notifications")
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

}
