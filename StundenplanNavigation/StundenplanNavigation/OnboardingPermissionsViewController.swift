//
//  OnboardingPermissionsViewController.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 21.11.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import UIKit
import EventKit

class OnboardingPermissionsViewController: UIViewController {
    @IBOutlet weak var synchronizationIsLoadingStackView: UIStackView!
    @IBOutlet weak var tutorialDescriptionView: UIView!
    @IBOutlet weak var saveChangesActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var SyncronisationStackView: UIStackView!
    @IBOutlet weak var calendarSynchronizationView: UIView!
    @IBOutlet weak var FinishOnboardingBarButton: UIBarButtonItem!
    @IBOutlet weak var TurnOnCalenderSynchronisationSwitch: UISwitch!
    
    var settingsController: SettingsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveChangesActivityIndicatorView.hidesWhenStopped = true
        applyChanges()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func applyChanges() {
        saveChangesActivityIndicatorView.startAnimating()
        DispatchQueue.global().async {
            self.settingsController.commitChanges()
            DispatchQueue.main.async {
                self.saveChangesActivityIndicatorView.stopAnimating()
                self.synchronizationIsLoadingStackView.isHidden = true
            }
        }
    }
    
    func setupUI(){
        TurnOnCalenderSynchronisationSwitch.onTintColor = appColor.tintColor
    }
    
    func askForCalendarPermissions() {
        EKEventStore().requestAccess(to: .event) { (succeed, error) in
            if succeed {
                DispatchQueue.main.async {
                    self.calendarSynchronizationView.isHidden = false
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }

    @IBAction func synchronizeSwitchAction(_ sender: UISwitch) {
        self.synchronizationIsLoadingStackView.isHidden = false
        self.saveChangesActivityIndicatorView.startAnimating()
        let isSwitchOn = sender.isOn
        DispatchQueue.global().async {
            if (isSwitchOn) {
                self.settingsController.startCalendarSync()
            } else {
                self.settingsController.stopCalendarSync()
            }
            DispatchQueue.main.async {
                self.saveChangesActivityIndicatorView.stopAnimating()
                self.SyncronisationStackView.isHidden = true
                self.FinishOnboardingBarButton.tintColor = appColor.tintColor
            }
        }
    }
    
    @IBAction func endOnboardingAction(_ sender: UIBarButtonItem) {
        //Notification
        let nc = NotificationCenter.default
        
        nc.post(name: .finishedOnboarding, object: nil)
        dismiss(animated: false)
    }
    
    @IBAction func askForCalendarPermissionsAction(_ sender: UIButton) {
        askForCalendarPermissions()
    }
}




