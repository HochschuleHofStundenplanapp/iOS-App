//
//  NetworkController.swift
//  CalendarAppFetchDEMO
//
//  Created by Sebastian Fuhrmann on 11.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import UIKit

class NetworkController: NSObject {

    var url = "http://studentenfutter.bplaced.net/getUser.php"    //Hier noch URL angeben
    
    
    
    func getData() -> NSMutableArray? {
        
        var dataArray : NSMutableArray? = nil
        let url = URL(string: self.url)
        let data = try? Data(contentsOf: url!)
        
        if data != nil{
            dataArray = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableArray
        }
        return dataArray
    }
    
    func getDataWithLogin() {
    
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
}
