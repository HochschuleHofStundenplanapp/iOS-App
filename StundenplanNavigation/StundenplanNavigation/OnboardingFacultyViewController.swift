//
//  OnboardingTemplate1ViewController.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 20.11.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import UIKit

class OnboardingFacultyViewController: UIViewController {
    @IBOutlet weak var facultySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tutorialDescriptionView: UIView!
    @IBOutlet weak var ScreenshotPreviewImageView: UIImageView!
    
    deinit {
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: NSNotification.Name.appColorHasChanged, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(setUpUI), name: NSNotification.Name.appColorHasChanged, object: nil)
        
        tutorialDescriptionView.applyShadow()
        
        setUpUI()
    }

    @objc func setUpUI() {
        self.facultySegmentedControl.tintColor = appColor.tintColor
        self.navigationController?.navigationBar.tintColor = appColor.tintColor
    }
    
    @IBAction func selectedFacultySegmentedControllAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            appColor.faculty = .economics
            ScreenshotPreviewImageView.image = #imageLiteral(resourceName: "Wirtschaft")
        case 1:
            appColor.faculty = .computerScience
            ScreenshotPreviewImageView.image = #imageLiteral(resourceName: "Informatik")
        case 2:
            appColor.faculty = .engineeringSciences
            ScreenshotPreviewImageView.image = #imageLiteral(resourceName: "Ingenieur")
        default:
            appColor.faculty = .default
            ScreenshotPreviewImageView.image = #imageLiteral(resourceName: "Standard")
        }
    }
    
}
