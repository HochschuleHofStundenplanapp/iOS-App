//
//  ViewController.swift
//  URLConnection
//
//  Copyright © 2016 Peter Stöhr. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBAction func doPressed(_ sender: AnyObject) {
        let urlString = "https://www.hof-university.de/soap/client.php?f=Courses&tt=SS"
        let username = "soapuser"
        let password = "F%98z&12"
        
        let passInfo = String(format: "%@:%@", username, password)
        let passData = passInfo.data(using: .utf8)
        let passCredential = passData?.base64EncodedString()
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.setValue("Basic \(passCredential!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            data, response, error in
            let str = String(data: data!, encoding: String.Encoding.utf8)
            print("\(str)")
            })
        task.resume()
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

