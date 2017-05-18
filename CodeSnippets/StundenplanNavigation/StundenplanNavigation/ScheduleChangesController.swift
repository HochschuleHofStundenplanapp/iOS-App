//
//  ScheduleChangesController.swift
//  StundenplanNavigation
//
//  Created by Andreas Wolf on 20.04.17.
//  Copyright © 2017 Haxnpeter. All rights reserved.
//

import UIKit

class ScheduleChangesController: NSObject, DataObserverProtocol{
    
    var myJobManager : JobManager = JobManager()
    let season = UserData.sharedInstance.selectedSeason
    let selectedLectures = UserData.sharedInstance.selectedLectures

    let debugurl = "https://app.hof-university.de/soap/client.php?f=Changes&stg=MC&sem=6&tt=SS"
    let debugurl2 = "https://app.hof-university.de/soap/client.php?f=Changes&stg=MI&sem=6&tt=SS"

    
    func handleChanges() -> Void
    {

        self.myJobManager.addNewObserver(o: self)
        

        
    
        
        //Settings.sharedInstance.savedChanges.changes = []
        // cntChanges = 0
        for lecture in selectedLectures.dropLast(){
          
            var splusname = lecture.splusname
            
           let selectedSemesters = UserData.sharedInstance.selectedSemesters
       
            splusname = splusname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            print("kappaspluname ->\(splusname)"  )
       
            let myUrl : String = "\(Constants.baseURI)client.php?f=Changes&id[]=\(splusname)"
            
            
            print("kappaUrlVorParsen ->\(myUrl)"  )
           
          //      let myUrl = debugurl
       // let myUrl2 = debugurl2

           //     let urlString = myUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
         //    print("kappaurl -> \(urlString)")
                
   //     let urlString2 = myUrl2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                myJobManager.NetworkJob(url: myUrl, username: Constants.username, password: Constants.password, isLastJob: false)

      
            }
            
          
        //Hole das Letzte Item der doppelten For-Schleife
        let lectureNameLastItem = selectedLectures.last!
     
        
      //  Markiere letzets Item im Job Manager
        print("kappa Lastspluname ->\(lectureNameLastItem.splusname)"  )
        
        var splusname = lectureNameLastItem.splusname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let lastUrl = "\(Constants.baseURI)client.php?f=Changes&id[]=\(splusname)"
        
        

        
       // let lastUrlString = lastUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
         print("kappaurl -> \(lastUrl)")
        
        
        myJobManager.NetworkJob(url: lastUrl, username: Constants.username, password: Constants.password,isLastJob: true)
        print("Letzen Job hinzugefügt")

    }
    
    /// speichert die zurückgegeben AnyObjects in ein AnyObjects Array
    ///
    /// - Parameter o: o Zurückgegebenes AnyObject
    func update (o:AnyObject) -> Void
    {
        print("Das Dataobject \(o)")
        let dataArray = o as! [(Data?, Error?)]
        
        
        
        for dataObject in dataArray {
            //print(String(data: dataObject.0!, encoding: String.Encoding.utf8)! as String)
            
            if let error = dataObject.1{
                // handle error
            }
            
            guard let data = dataObject.0 else {
                return
            }
            print(String(data: dataObject.0!, encoding: String.Encoding.utf8)! as String)
            //TODO: JsonChanges muss umgeschrieben werden - Darf kein Course erwarten ..
            
            // Settings.sharedInstance.savedChanges.addChanges(cl: (JsonChanges(data: dataObject)))
        }
        
     print("ScheduleChanges Controller All Jobs Done")
        
    }
    /// Bricht im JobManager alle Netzwerkjobs ab
   func cancelAllNetworkJobs() -> Void  {
        myJobManager.cancelAllNetworkJobs()
        
    }
    
}
