//
//  PopUpMenueViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 17.01.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class PopUpMenueViewController: UIViewController {
    
    var lecturesTableViewController : LecturesTableViewController!
    var lecturesDelegate: LecturesTableViewDelegate!
    @IBOutlet var stroke: UIView!
    
    @IBAction func selectAllButton(_ sender: Any) {
        LectureController().selectAllLectures()
        self.lecturesTableViewController.lectureTableView.reloadData()
        self.dismiss(animated: true) { }
    }
    
    @IBAction func deSelectAll(_ sender: Any) {
        LectureController().deselectAllLectures()
        self.lecturesTableViewController.lectureTableView.reloadData()
        self.dismiss(animated: true) { }
    }
    
    func setMainViewController(lecturesTableViewController : LecturesTableViewController){
        self.lecturesTableViewController = lecturesTableViewController
    }
    
    func setBorder(){
        self.view.layer.borderWidth = 1.0
        self.view.layer.borderColor = UIColor.hawBlue.cgColor
        self.view.layer.cornerRadius = 13.0;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stroke.backgroundColor = UIColor.hawBlue
    }
}
