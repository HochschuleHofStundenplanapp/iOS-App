//
//  OnboardingLecturesViewController.swift
//  StundenplanNavigation
//
//  Created by Marcel Hagmann on 21.11.17.
//  Copyright © 2017 Hof University. All rights reserved.
//

import UIKit

class OnboardingLecturesViewController: UIViewController {
    @IBOutlet var lectureTableView: UITableView!
    @IBOutlet weak var btnSelectAll: UIButton!
    @IBOutlet weak var btnDeselectAll: UIButton!
    @IBOutlet weak var tutorialDescriptionView: UIView!
    
    
    var dataSource : LecturesTableViewDataSource!
    var delegate: LecturesTableViewDelegate!
    var lectureController: LectureController!
    
    var settingsController: SettingsController!
    
    var tmpSelectedLectures: TmpSelectedLectures!
    var tmpSelectedSemesters: TmpSelectedSemesters!
    var tmpSelectedSeason: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tutorialDescriptionView.applyShadow()
        
        lectureController = LectureController(tmpSelectedLectures: tmpSelectedLectures, tmpSelectedSemesters: tmpSelectedSemesters, tmpSelectedSeason: tmpSelectedSeason)
        
        dataSource = LecturesTableViewDataSource(tmpSelectedLectures: tmpSelectedLectures)
        lectureTableView.dataSource = dataSource
        
        delegate = LecturesTableViewDelegate(lectureController: lectureController)
        lectureTableView.delegate = delegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadEnded), name: .lecturesDownloadEnded, object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.showNoInternetAlert), name: .lecturesDownloadFailed, object: nil )
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lectureController.loadAllLectures()
    }
    
    func setUpUI() {
        btnSelectAll.setTitleColor(appColor.tintColor, for: .normal)
        btnDeselectAll.setTitleColor(appColor.tintColor, for: .normal)
    }
    
    @objc func downloadEnded(){
        self.lectureTableView.reloadData()
    }
    
    @objc func showNoInternetAlert(){
        let alertController = UIAlertController(title: "Achtung", message:
            "Keine Verbindung zum Internet. Bitte prüfen Sie ihre Internetverbindung.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
        } ))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OnboardingToPermissions" {
            let destinationCtrl = segue.destination as! OnboardingPermissionsViewController
            destinationCtrl.settingsController = settingsController
        }
    }
    
    func checkIfCanPassScreen() {
        if tmpSelectedLectures.getOneDimensionalList().count != 0 {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @IBAction func selectAllButton(_ sender: Any) {
        lectureController.selectAllLectures()
        lectureTableView.reloadData()
        checkIfCanPassScreen()
    }
    
    @IBAction func deSelectAll(_ sender: Any) {
        lectureController.deselectAllLectures()
        lectureTableView.reloadData()
        checkIfCanPassScreen()
    }
}
