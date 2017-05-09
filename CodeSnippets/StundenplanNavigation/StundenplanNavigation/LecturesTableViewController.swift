//
//  LecturesTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class LecturesTableViewController: UITableViewController {

    @IBOutlet var selectAllButton: UIBarButtonItem!
    @IBOutlet var lectureTableView: UITableView!
    var dataSource : LecturesTableViewDataSource!
    var delegate: LecturesTableViewDelegate!
    var lectureController: LectureController!
    
    var popUpMenueVC : PopUpMenueViewController!
    var popUpMenueDelegate : PopUpMenueDelegate = PopUpMenueDelegate()
    
    @IBAction func selectAllCells(_ sender: UIBarButtonItem) {
        let popUpVC = storyboard?.instantiateViewController(withIdentifier: "popUpMenue") as! PopUpMenueViewController
        
        popUpVC.modalPresentationStyle = .popover
        popUpVC.preferredContentSize = CGSize(width: 160, height: 100)
        popUpVC.mainViewController = self
        popUpVC.setBorder()
        
        if let popoverController = popUpVC.popoverPresentationController {
            popoverController.barButtonItem = self.selectAllButton
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            popoverController.delegate = popUpMenueDelegate
        }
        present(popUpVC, animated: true, completion: nil)
        popUpMenueVC = popUpVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        tabBarController?.tabBar.tintColor = UIColor.hawBlue
        
        lectureController = LectureController()
        
        dataSource = LecturesTableViewDataSource(tableView: self)
        lectureTableView.dataSource = dataSource
        
        delegate = LecturesTableViewDelegate()
        lectureTableView.delegate = delegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lectureController.loadAllLectures()
    }
    
    func beginDownload(){
        //Show Activity Indicator
    }
    
    func endDownload(){
        lectureTableView.reloadData()
    }
    
    func showNoInternetAlert(){
        let alertController = UIAlertController(title: "Internetverbindung fehlgeschlagen", message:
            "Bitte verbinden Sie sich mit dem Internet", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            //Daten erneut laden
        } ))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //Wird vom Delegate aus aufgerufen
    func switchSelectAllButtonIcon(iconName: String){
        let buttonImage = UIImage(named: "\(iconName)")?.withRenderingMode(.alwaysOriginal)
        selectAllButton.image = buttonImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
