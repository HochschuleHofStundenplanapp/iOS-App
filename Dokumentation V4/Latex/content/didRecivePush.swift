func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
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