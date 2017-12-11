//
//  NetworkController.swift
//  CalendarDemo
//
//  Created by Sebastian Fuhrmann on 12.10.16.
//  Copyright © 2016 Sebastian Fuhrmann. All rights reserved.
//

import UIKit

class GetDataFromInternet: NSObject, JobDataObservableProtocol {
    var myObservers = [JobDataObserverProtocol]()
    var position : Int = -1
    
   
    func doItWithUrl(url: String, username: String?, password: String?, position: Int ) -> Void
    {
        print("do it with url: \(url) position : \(position)")
        self.position = position
        let urlString = url
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)

        
        if (username != nil && password != nil)
        {
            let passInfo = String(format: "%@:%@", username!, password!)
            let passData = passInfo.data(using: .utf8)
            let passCredential = passData?.base64EncodedString()
            request.setValue("Basic \(passCredential!)", forHTTPHeaderField: "Authorization")

        }
         request.httpMethod = "POST"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            data, response, error in
            
            DispatchQueue.main.async(execute: { () -> Void in
                //Benachrichtige Alle Observer mit den Daten
                
                //let jsonString = String(data: data!, encoding: String.Encoding.utf8)
//                print(jsonString)
                print("-----")
                
                let dataWithErrorTuple = (data,error)
                
                self.notifiyAllObservers(o: dataWithErrorTuple as AnyObject,p: position)
            })
        })
        task.resume()

        
    }
    
    
    /// Fügt einen neuen Observer der Klasse JobManager hinzu
    ///
    /// - parameter o: Die Observerklasse, welche DataObserverProtocol implementiert
    func addNewObserver (o: JobDataObserverProtocol) -> Void
    {
        myObservers.append(o)
       }
    
    /// Entfernt den übergebenen Observer von der Klasse Settings
    ///
    /// - parameter o: o Die Observerklasse, welche DataObserverProtocol implementiert
    func removeOldObserver (o: JobDataObserverProtocol) -> Void
    {
        if let i = myObservers.index(where: { $0 === o }) {
            myObservers.remove(at: i)
            print("GetDataFromInternet Observer wurde entfernt")
        }
        
    }
    /// Benachrichtigt alle Observer über eine Veränderung
    ///
    /// - parameter s: Optional: Fehlermeldung
    func notifiyAllObservers(o: AnyObject, p: Int) -> Void
    {
               for observer in myObservers
        {
            
            observer.update(o: o as AnyObject, p: self.position)
        }
         self.position = -1
        
    }

    
    
 }
