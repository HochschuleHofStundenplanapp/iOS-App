//
//  OnboardingPermissionsCalendarViewController.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 12.01.18.
//  Copyright © 2018 Hof University. All rights reserved.
//

import UIKit

class OnboardingPermissionsPushViewController: UIViewController {
    
    var settingsController: SettingsController!

    override func viewDidLoad() {
        super.viewDidLoad()
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
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.registerForPushNotification()
        }
    }
}
