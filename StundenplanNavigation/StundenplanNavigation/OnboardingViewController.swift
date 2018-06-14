//
//  OnboardingViewController.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 20.11.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import UIKit
import StundenplanFramework

struct OnboardingIDs {
    private init() {}
    
    static let onboardingStartID = "OnboardingStartViewControllerID"
    
    static let facultyID = "onboardingFacultyID"
    static let courseID = "onboardingCourseID"
}

class OnboardingViewController: UIViewController {
    @IBOutlet weak var labVersion: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            labVersion.text = "Version: \(version)"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if hasFinishedOnboarding() {
            dismiss(animated: false)
        }
    }
    
    @IBAction func AbortOnboarding(_ sender: Any) {
        //Notification
        let nc = NotificationCenter.default
        
        nc.post(name: .finishedOnboarding, object: nil)
        dismiss(animated: true)
    }
    
    func hasFinishedOnboarding() -> Bool {
        if UserData.sharedInstance.finishedOnboarding {
            return true
        } else {
            return false
        }
    }

}
