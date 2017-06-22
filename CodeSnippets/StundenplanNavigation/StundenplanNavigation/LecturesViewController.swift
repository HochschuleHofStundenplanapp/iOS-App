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
    
    var popUpMenueVC : PopUpMenueViewController!
    var popUpMenueDelegate : PopUpMenueDelegate = PopUpMenueDelegate()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lectureController.loadAllLectures()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        lectureController.cancelLoading()
    }
    
    func downloadEnded(){
        self.lectureTableView.reloadData()
    }
    
    func showNoInternetAlert(){
        let alertController = UIAlertController(title: "Internetverbindung fehlgeschlagen", message:
            "Bitte verbinden Sie sich mit dem Internet", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
        } ))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //Wird vom Delegate aus aufgerufen
//    func switchSelectAllButtonIcon(iconName: String){
//        let buttonImage = UIImage(named: "\(iconName)")?.withRenderingMode(.alwaysOriginal)
//        selectAllButton.image = buttonImage
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
