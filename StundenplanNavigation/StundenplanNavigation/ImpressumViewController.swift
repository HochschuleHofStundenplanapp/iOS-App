//
//  ImpressumViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 29.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class ImpressumViewController: UIViewController {

    @IBOutlet weak var textContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.tintColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textContent.contentOffset.y = -textContent.contentInset.top
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
