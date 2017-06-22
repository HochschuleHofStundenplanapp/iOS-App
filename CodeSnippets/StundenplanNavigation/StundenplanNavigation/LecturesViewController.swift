//
//  LecturesViewController.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 22.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class LecturesViewController: UIViewController {

//    @IBOutlet var selectAllButton: UIBarButtonItem!
    @IBOutlet var lectureTableView: UITableView!
    var dataSource : LecturesTableViewDataSource!
    var delegate: LecturesTableViewDelegate!
    var lectureController: LectureController!
    
    var tmpSelectedLectures : TmpSelectedLectures!
        
    @IBAction func selectAllButton(_ sender: Any) {
        lectureController.selectAllLectures()
        lectureTableView.reloadData()
    }
    
    @IBAction func deSelectAll(_ sender: Any) {
        lectureController.deselectAllLectures()
        lectureTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        tabBarController?.tabBar.tintColor = UIColor.hawBlue
        
        tabBarController?.tabBar.isHidden = true
        
        lectureController = LectureController(tmpSelectedLectures: tmpSelectedLectures)
        
        dataSource = LecturesTableViewDataSource(tmpSelectedLectures: tmpSelectedLectures)
        lectureTableView.dataSource = dataSource
        
        delegate = LecturesTableViewDelegate(lectureController: lectureController)
        lectureTableView.delegate = delegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadEnded), name: .lecturesDownloadEnded, object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.showNoInternetAlert), name: .lecturesDownloadFailed, object: nil )
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
    
    func downloadEnded(){
        self.lectureTableView.reloadData()
    }
    
    func showNoInternetAlert(){
        let alertController = UIAlertController(title: "Achtung", message:
            "Keine Verbindung zum Internet. Bitte prüfen Sie ihre Internetverbindung.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
        } ))
        self.present(alertController, animated: true, completion: nil)
    }
}
