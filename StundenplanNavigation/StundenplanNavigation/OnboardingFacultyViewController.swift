//
//  OnboardingTemplate1ViewController.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 20.11.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import UIKit
import StundenplanFramework

class OnboardingFacultyViewController: UIViewController {
    @IBOutlet weak var facultySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tutorialDescriptionView: UIView!
    @IBOutlet weak var ScreenshotPreviewImageView: UIImageView!
    
    deinit {
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: NSNotification.Name.appColorHasChanged, object: nil)
    }
    @IBAction func abortOnboarding(_ sender: Any) {
        //Notification
        let nc = NotificationCenter.default
        UserData.sharedInstance.finishedOnboarding = true
        nc.post(name: .finishedOnboarding, object: nil)
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(setUpUI), name: NSNotification.Name.appColorHasChanged, object: nil)
        
        //Beim Starten des Onboardings wird die Farbe wieder auf Default gesetzt
        appColor.faculty = .default
        UserData.sharedInstance.setSelectedAppColor(newAppColor: Faculty.default.faculty)
        
        setUpUI()
    }

    @objc func setUpUI() {
        self.facultySegmentedControl.tintColor = appColor.tintColor
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = appColor.tintColor
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.compactAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            self.navigationController?.navigationBar.tintColor = appColor.navigationBarTintColor
            self.navigationController?.navigationBar.barTintColor = appColor.tintColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:appColor.navigationBarTintColor]
        }
    }
    
    @IBAction func selectedFacultySegmentedControllAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            appColor.faculty = .economics
            UserData.sharedInstance.setSelectedAppColor(newAppColor: Faculty.economics.faculty)
            ScreenshotPreviewImageView.image = #imageLiteral(resourceName: "Wirtschaft")
        case 1:
            appColor.faculty = .computerScience
            ScreenshotPreviewImageView.image = #imageLiteral(resourceName: "Informatik")
            UserData.sharedInstance.setSelectedAppColor(newAppColor: Faculty.computerScience.faculty)
        case 2:
            appColor.faculty = .engineeringSciences
            ScreenshotPreviewImageView.image = #imageLiteral(resourceName: "Ingenieur")
            UserData.sharedInstance.setSelectedAppColor(newAppColor: Faculty.engineeringSciences.faculty)
        default:
            appColor.faculty = .default
            ScreenshotPreviewImageView.image = #imageLiteral(resourceName: "Standard")
            UserData.sharedInstance.setSelectedAppColor(newAppColor: Faculty.default.faculty)
        }
        setUpUI()
    }
    
}
