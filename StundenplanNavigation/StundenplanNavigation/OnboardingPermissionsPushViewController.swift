//
//  OnboardingPermissionsCalendarViewController.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 12.01.18.
//  Copyright © 2018 Hof University. All rights reserved.
//

import UIKit
import UserNotifications

class OnboardingPermissionsPushViewController: UIViewController {
    
    var settingsController: SettingsController!

    @IBOutlet weak var butRequestPush: UIButton!
    @IBOutlet weak var labInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                print("push allowed")
                
                print("onboarding register for remote notifications")
                UIApplication.shared.registerForRemoteNotifications()
                
                self.butRequestPush.isEnabled = false
                self.labInfo.text = "Push bereits erlaubt"
            } else {
                print("push not allowed")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OnboardingToPermissionsCalendar" {
            let destinationCtrl = segue.destination as! OnboardingPermissionsCalendarViewController
            destinationCtrl.settingsController = settingsController
        }
    }
    
    @IBAction func requestPushNotificationPermissionAction(_ sender: UIButton) {
        var allowed = false
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                print("onboarding push allowed")
                allowed = true

                UIApplication.shared.registerForRemoteNotifications()
            } else {
                allowed = false
                print("onboarding push not allowed")
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.registerForPushNotification()
                    sleep(2)
                    print("erneute Anfrage..")
                    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                        if settings.authorizationStatus == .authorized {
                            print("onboarding again push allowed")
                            allowed = true
                            
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            }
        }
        
        if allowed {
            self.butRequestPush.isEnabled = false
            self.labInfo.text = "Push erfolgreich erlaubt"
        } else {
            self.butRequestPush.isEnabled = false
            self.labInfo.text = "Push kann nicht aktiviert werden.\nPrüfe Deine Einstellungen in iOS unter Mitteilungen."
        }
    }
}
