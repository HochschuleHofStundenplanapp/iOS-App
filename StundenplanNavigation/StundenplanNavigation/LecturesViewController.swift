//
//  LecturesViewController.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 22.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit
import EventKit

class LecturesViewController: UIViewController {

//    @IBOutlet var selectAllButton: UIBarButtonItem!
    @IBOutlet var lectureTableView: UITableView!
    @IBOutlet weak var btnSelectAll: UIButton!
    @IBOutlet weak var btnDeselectAll: UIButton!
    var dataSource : LecturesTableViewDataSource!
    var delegate: LecturesTableViewDelegate!
    var lectureController: LectureController!
    
    var tmpSelectedLectures: TmpSelectedLectures!
    var tmpSelectedSemesters: TmpSelectedSemesters!
    var tmpSelectedSeason: String!
    
    var settingsController: SettingsController!
    let backgroundProgressIndicator = ActivityIndicator()
        
    @IBAction func selectAllButton(_ sender: Any) {
        lectureController.selectAllLectures()
        lectureTableView.reloadData()
    }
    
    @IBAction func deSelectAll(_ sender: Any) {
        lectureController.deselectAllLectures()
        lectureTableView.reloadData()
    }
    
    @IBAction func saveSelectedLecture(_ sender: Any) {
        backgroundProgressIndicator.startActivityIndicator(root: self)
        DispatchQueue.global().async {
            self.settingsController.commitChanges()
            DispatchQueue.main.async {
                //UIApplication.shared.registerForRemoteNotifications()
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else {
                    return
                }
                appDelegate.registerForPushNotification()
                self.backgroundProgressIndicator.stopActivityIndicator()
            }
        }
        
        //print("save selected lectures")
        
        navigationController!.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.tintColor = UIColor.white
//        tabBarController?.tabBar.tintColor = UIColor.hawBlue
        
        tabBarController?.tabBar.isHidden = true
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false

        NotificationCenter.default.removeObserver(self)
        lectureController.cancelLoading()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {

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
}
