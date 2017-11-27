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
        case 0: appColor.faculty = .economics
        case 1: appColor.faculty = .computerScience
        case 2: appColor.faculty = .engineeringSciences
        default: appColor.faculty = .default
        }
    }
    
}
