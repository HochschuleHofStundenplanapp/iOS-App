//
//  TaskViewController.swift
//  StundenplanNavigation
//
//  Created by Patrick Niepel on 16.10.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            setupNavBar()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 11.0, *)
    private func setupNavBar() {
         navigationController?.navigationBar.prefersLargeTitles = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
