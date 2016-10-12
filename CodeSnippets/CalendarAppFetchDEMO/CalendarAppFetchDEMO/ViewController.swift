//
//  ViewController.swift
//  CalendarAppFetchDEMO
//
//  Created by Sebastian Fuhrmann on 11.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var array : NSMutableArray = []
    var nc : NetworkController? = nil
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print()
        nc = NetworkController()
        while i < 100 {
        let thread = Thread(target: self, selector: #selector(ViewController.fetch), object: nil)
            thread.start()
        i += 1
        }
        
    }
    
    func fetch(){
        
        self.nc?.getDataWithLogin()
//        print(array.description)
//        print("Thread: \(i)")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

