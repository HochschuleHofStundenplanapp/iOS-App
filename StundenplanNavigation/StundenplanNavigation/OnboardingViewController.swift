//
//  OnboardingViewController.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 20.11.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import UIKit

struct OnboardingIDs {
    private init() {}
    
    static let onboardingStartID = "OnboardingStartViewControllerID"
    
    static let facultyID = "onboardingFacultyID"
    static let courseID = "onboardingCourseID"
}

class OnboardingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if hasFinishedOnboarding() {
            dismiss(animated: false)
        }
    }
    
    func hasFinishedOnboarding() -> Bool {
        if UserData.sharedInstance.selectedCourses.isEmpty {
            return false
        } else {
            return true
        }
    }

}
