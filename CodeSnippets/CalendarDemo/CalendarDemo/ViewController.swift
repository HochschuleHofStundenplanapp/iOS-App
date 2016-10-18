//
//  ViewController.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 12.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let nc = NetworkController()
        
//        nc.loadCourses(ssws: "SS")
        nc.loadChanges(ssws: "WS", semester: "5", stg: "MC")
//        nc.loadSchedule(ssws: "WS", semester: "5", stg: "MC")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

